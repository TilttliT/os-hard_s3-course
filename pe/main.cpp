#include <cassert>
#include <fstream>
#include <cstring>
#include <iostream>
#include <vector>

size_t read_number(std::ifstream &fin, size_t addr, size_t size) {
    fin.seekg(addr);
    size_t res = 0;
    char tmp;
    for (size_t i = 0, mult = 1; i < size; ++i, mult *= 256) {
        fin.get(tmp);
        res += (unsigned char) tmp * mult;
    }
    return res;
}

std::vector<char> read_chars(std::ifstream &fin, size_t addr, size_t size) {
    fin.seekg(addr);
    std::vector<char> res;
    char tmp;
    for (size_t i = 0; i < size; ++i) {
        fin.get(tmp);
        res.push_back(tmp);
    }
    return res;
}

std::string read_string(std::ifstream &fin, size_t addr) {
    fin.seekg(addr);
    std::string res;
    char tmp;
    fin.get(tmp);
    while (tmp != 0) {
        res += tmp;
        fin.get(tmp);
    }
    return res;
}

size_t get_raw_by_rva(std::ifstream &fin, size_t addr_of_rva, size_t addr_of_pe) {
    size_t rva = read_number(fin, addr_of_rva, 4);
    size_t addr = addr_of_pe + 24 + 240;
    size_t section_rva, section_raw;
    for (size_t section_virtual_size;; addr += 40) {
        section_virtual_size = read_number(fin, addr + 8, 4);
        section_rva = read_number(fin, addr + 12, 4);
        section_raw = read_number(fin, addr + 20, 4);
        if (rva >= section_rva && rva <= section_rva + section_virtual_size) {
            break;
        }
    }
    return section_raw + rva - section_rva;
}

bool check_vector_is_zero(std::vector<char> const &v) {
    for (auto x: v) {
        if (x != 0) return false;
    }
    return true;
}

int main(int argc, char *argv[]) {
    assert(argc == 3 && "Wrong number of command line arguments");

    std::ifstream fin(argv[2], std::ifstream::binary);
    assert(fin.is_open() && "File can't be open");
    size_t addr_of_pe = read_number(fin, 0x3C, 2);
    if (strcmp(argv[1], "is-pe") == 0) {
        auto res = read_chars(fin, addr_of_pe, 4);
        if (res[0] != 'P' || res[1] != 'E' || res[2] != 0 || res[3] != 0) {
            std::cout << "Not PE" << std::endl;
            return 1;
        }
        std::cout << "PE" << std::endl;
    } else if (strcmp(argv[1], "import-functions") == 0) {
        size_t import_table_raw = get_raw_by_rva(fin, addr_of_pe + 24 + 0x78, addr_of_pe);
        for (size_t i = 0;; ++i) {
            auto dll = read_chars(fin, import_table_raw + 20 * i, 20);
            if (check_vector_is_zero(dll)) break;
            size_t dll_raw = get_raw_by_rva(fin, import_table_raw + 20 * i + 0xC, addr_of_pe);
            std::cout << read_string(fin, dll_raw) << std::endl;

            size_t import_lookup_table_raw = get_raw_by_rva(fin, import_table_raw + 20 * i, addr_of_pe);
            for (size_t j = 0;; ++j) {
                auto lookup = read_chars(fin, import_lookup_table_raw + 8 * j, 8);
                if (check_vector_is_zero(lookup)) break;
                if ((unsigned char) lookup[7] & (1 << 7)) continue;
                size_t func_name_raw = get_raw_by_rva(fin, import_lookup_table_raw + 8 * j, addr_of_pe);
                std::cout << "    " << read_string(fin, func_name_raw + 2) << std::endl;
            }
        }
    } else if (strcmp(argv[1], "export-functions") == 0) {
        size_t export_table_raw = get_raw_by_rva(fin, addr_of_pe + 24 + 0x70, addr_of_pe);
        size_t number_of_functions = read_number(fin, export_table_raw + 0x18, 4);
        size_t name_table_raw = get_raw_by_rva(fin, export_table_raw + 0x20, addr_of_pe);
        for (size_t i = 0; i < number_of_functions; ++i) {
            size_t func_name_raw = get_raw_by_rva(fin, name_table_raw + 4 * i, addr_of_pe);
            std::cout << read_string(fin, func_name_raw) << std::endl;
        }
    } else {
        assert(false && "This parser mode is not supported");
    }

    return 0;
}
