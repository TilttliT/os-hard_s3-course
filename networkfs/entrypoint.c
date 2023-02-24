#include <linux/fs.h>
#include <linux/init.h>
#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/slab.h>

#include "http.h"

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Kutasin Vladimir");
MODULE_VERSION("0.01");

struct inode *networkfs_get_inode(struct super_block *sb,
                                  const struct inode *dir, umode_t mode,
                                  int i_ino);

struct entry_info {
  unsigned char entry_type;  // DT_DIR (4) or DT_REG (8)
  ino_t ino;
};

#define I2A(v) "0123456789ABCDEF"[v]

void update_str(const char *str, char *new_str, int size) {
  int j = 0;
  for (int i = 0; i < size; ++i) {
    if ((str[i] < 'a' || str[i] > 'z') && (str[i] < 'A' || str[i] > 'Z') &&
        (str[i] < '0' || str[i] > '9')) {
      new_str[j++] = '%';
      new_str[j++] = I2A(str[i] / 16);
      new_str[j++] = I2A(str[i] % 16);
    } else {
      new_str[j++] = str[i];
    }
  }
  new_str[j] = 0;
}

int http_lookup(ino_t parent, const char *name, struct entry_info *e_inf,
                const char *token) {
  char parent_string[20];
  char new_name[3 * 256];
  update_str(name, new_name, strlen(name));
  sprintf(parent_string, "%lu", parent);
  return networkfs_http_call(token, "lookup", (char *)e_inf, sizeof(*e_inf), 2,
                             "parent", parent_string, "name", new_name);
}

struct dentry *networkfs_lookup(struct inode *parent_inode,
                                struct dentry *child_dentry,
                                unsigned int flag) {
  ino_t root;
  struct inode *inode;
  struct entry_info e_inf;
  const char *name = child_dentry->d_name.name;
  root = parent_inode->i_ino;
  if (http_lookup(root, name, &e_inf, parent_inode->i_sb->s_fs_info) == 0) {
    inode = networkfs_get_inode(
        parent_inode->i_sb, NULL,
        (e_inf.entry_type == DT_DIR ? S_IFDIR : S_IFREG), e_inf.ino);
    d_add(child_dentry, inode);
    return child_dentry;
  } else {
    return NULL;
  }
}

int http_create(ino_t parent, const char *name, const char *type, ino_t *ret,
                const char *token) {
  char parent_string[20];
  char new_name[3 * 256];
  update_str(name, new_name, strlen(name));
  sprintf(parent_string, "%lu", parent);
  return networkfs_http_call(token, "create", (char *)ret, sizeof(*ret), 3,
                             "parent", parent_string, "name", new_name, "type",
                             type);
}

int networkfs_create(struct user_namespace *, struct inode *parent_inode,
                     struct dentry *child_dentry, umode_t mode, bool b) {
  int err;
  ino_t root;
  const char *name = child_dentry->d_name.name;
  root = parent_inode->i_ino;
  ino_t child_inode;
  if ((err = http_create(root, name, "file", &child_inode,
                         parent_inode->i_sb->s_fs_info)) != 0) {
    return err;
  }
  d_add(child_dentry,
        networkfs_get_inode(parent_inode->i_sb, NULL, S_IFREG, child_inode));
  return 0;
}

int http_unlink(ino_t parent, const char *name, const char *token) {
  char parent_string[20];
  char new_name[3 * 256];
  update_str(name, new_name, strlen(name));
  sprintf(parent_string, "%lu", parent);
  return networkfs_http_call(token, "unlink", NULL, 0, 2, "parent",
                             parent_string, "name", new_name);
}

int networkfs_unlink(struct inode *parent_inode, struct dentry *child_dentry) {
  const char *name = child_dentry->d_name.name;
  ino_t root;
  root = parent_inode->i_ino;
  return http_unlink(root, name, parent_inode->i_sb->s_fs_info);
}

int networkfs_mkdir(struct user_namespace *, struct inode *parent_inode,
                    struct dentry *child_dentry, umode_t mode) {
  int err;
  ino_t root;
  const char *name = child_dentry->d_name.name;
  root = parent_inode->i_ino;
  ino_t child_inode;
  if ((err = http_create(root, name, "directory", &child_inode,
                         parent_inode->i_sb->s_fs_info)) != 0) {
    return err;
  }
  d_add(child_dentry,
        networkfs_get_inode(parent_inode->i_sb, NULL, S_IFDIR, child_inode));
  return 0;
}

int http_rmdir(ino_t parent, const char *name, const char *token) {
  char parent_string[20];
  char new_name[3 * 256];
  update_str(name, new_name, strlen(name));
  sprintf(parent_string, "%lu", parent);
  return networkfs_http_call(token, "rmdir", NULL, 0, 2, "parent",
                             parent_string, "name", new_name);
}

int networkfs_rmdir(struct inode *parent_inode, struct dentry *child_dentry) {
  const char *name = child_dentry->d_name.name;
  ino_t root;
  root = parent_inode->i_ino;
  return http_rmdir(root, name, parent_inode->i_sb->s_fs_info);
}

int http_link(ino_t source, ino_t parent, const char *name, const char *token) {
  char source_string[20];
  char parent_string[20];
  char new_name[3 * 256];
  update_str(name, new_name, strlen(name));
  sprintf(source_string, "%lu", source);
  sprintf(parent_string, "%lu", parent);
  return networkfs_http_call(token, "link", NULL, 0, 3, "source", source_string,
                             "parent", parent_string, "name", new_name);
}

int networkfs_link(struct dentry *old_dentry, struct inode *parent_dir,
                   struct dentry *new_dentry) {
  const char *name = new_dentry->d_name.name;
  ino_t source = old_dentry->d_inode->i_ino;
  ino_t parent = parent_dir->i_ino;
  return http_link(source, parent, name, parent_dir->i_sb->s_fs_info);
}

struct inode_operations networkfs_inode_ops = {
    .lookup = networkfs_lookup,
    .create = networkfs_create,
    .unlink = networkfs_unlink,
    .mkdir = networkfs_mkdir,
    .rmdir = networkfs_rmdir,
    .link = networkfs_link,
};

struct entries {
  size_t entries_count;
  struct entry {
    unsigned char entry_type;  // DT_DIR (4) or DT_REG (8)
    ino_t ino;
    char name[256];
  } entries[16];
};

int http_list(ino_t inode, struct entries *entr, const char *token) {
  char inode_string[20];
  sprintf(inode_string, "%lu", inode);
  return networkfs_http_call(token, "list", (char *)entr, sizeof(*entr), 1,
                             "inode", inode_string);
}

int networkfs_iterate(struct file *filp, struct dir_context *ctx) {
  char fsname[256];
  struct entries *entr;
  struct dentry *dentry;
  struct inode *inode;
  unsigned long offset;
  int stored;
  unsigned char ftype;
  ino_t ino;
  ino_t dino;
  entr = kmalloc(sizeof(struct entries), GFP_KERNEL);
  if (entr == NULL) {
    return -ENOMEM;
  }
  dentry = filp->f_path.dentry;
  inode = dentry->d_inode;
  offset = filp->f_pos;
  stored = 0;
  ino = inode->i_ino;
  if (http_list(ino, entr, inode->i_sb->s_fs_info) != 0) return -ENOMEM;
  while (true) {
    if (offset == 0) {
      strcpy(fsname, ".");
      ftype = DT_DIR;
      dino = ino;
    } else if (offset == 1) {
      strcpy(fsname, "..");
      ftype = DT_DIR;
      dino = dentry->d_parent->d_inode->i_ino;
    } else if (offset - 2 < entr->entries_count) {
      strcpy(fsname, entr->entries[offset - 2].name);
      ftype = entr->entries[offset - 2].entry_type;
      dino = entr->entries[offset - 2].ino;
    } else {
      break;
    }
    dir_emit(ctx, fsname, strlen(fsname), dino, ftype);
    stored++;
    offset++;
    ctx->pos = offset;
  }
  kfree(entr);
  return stored;
}

struct file_operations networkfs_dir_ops = {
    .iterate = networkfs_iterate,
};

struct content {
  u64 content_length;
  char content[512];
};

int http_read(ino_t inode, struct content *cont, const char *token) {
  char inode_string[20];
  sprintf(inode_string, "%lu", inode);
  return networkfs_http_call(token, "read", (char *)cont, sizeof(*cont), 1,
                             "inode", inode_string);
}

ssize_t networkfs_read(struct file *filp, char *buffer, size_t len,
                       loff_t *offset) {
  struct dentry *dentry;
  struct inode *inode;
  struct content cont;
  ino_t ino;

  dentry = filp->f_path.dentry;
  inode = dentry->d_inode;
  ino = inode->i_ino;
  if (http_read(ino, &cont, inode->i_sb->s_fs_info) != 0) return -1;
  if (cont.content_length - *offset < len) len = cont.content_length - *offset;
  len -= copy_to_user(buffer, cont.content + *offset, len);
  *offset += len;
  return len;
}

int http_write(ino_t inode, const char *content, size_t len,
               const char *token) {
  int err;
  char *new_content = kmalloc(3 * len, GFP_KERNEL);
  if (new_content == NULL) {
    return -ENOMEM;
  }
  update_str(content, new_content, len);
  char inode_string[20];
  sprintf(inode_string, "%lu", inode);
  err = networkfs_http_call(token, "write", NULL, 0, 2, "inode", inode_string,
                            "content", new_content);
  kfree(new_content);
  return err;
}

ssize_t networkfs_write(struct file *filp, const char *buffer, size_t len,
                        loff_t *offset) {
  struct dentry *dentry;
  struct inode *inode;
  char *content = kmalloc(len, GFP_KERNEL);
  ino_t ino;

  dentry = filp->f_path.dentry;
  inode = dentry->d_inode;
  ino = inode->i_ino;
  if (copy_from_user(content, buffer, len)) {
    kfree(content);
    return -EFAULT;
  }
  if (http_write(ino, content, len, inode->i_sb->s_fs_info) != 0) {
    kfree(content);
    return -1;
  }
  *offset += len;
  kfree(content);
  return len;
}

struct file_operations networkfs_file_ops = {
    .read = networkfs_read,
    .write = networkfs_write,
};

struct inode *networkfs_get_inode(struct super_block *sb,
                                  const struct inode *dir, umode_t mode,
                                  int i_ino) {
  struct inode *inode;
  inode = new_inode(sb);
  if (inode != NULL) {
    inode->i_ino = i_ino;
    inode->i_op = &networkfs_inode_ops;
    if (S_ISDIR(mode)) {
      inode->i_fop = &networkfs_dir_ops;
    } else {
      inode->i_fop = &networkfs_file_ops;
    }
    inode_init_owner(&init_user_ns, inode, dir, mode | S_IRWXUGO);
  }
  return inode;
}

int networkfs_fill_super(struct super_block *sb, void *data, int silent) {
  struct inode *inode;
  inode = networkfs_get_inode(sb, NULL, S_IFDIR, 1000);
  sb->s_root = d_make_root(inode);
  if (sb->s_root == NULL) {
    return -ENOMEM;
  }
  printk(KERN_INFO "return 0\n");
  return 0;
}

struct dentry *networkfs_mount(struct file_system_type *fs_type, int flags,
                               const char *token, void *data) {
  struct dentry *ret;
  ret = mount_nodev(fs_type, flags, data, networkfs_fill_super);
  if (ret == NULL) {
    printk(KERN_ERR "Can't mount file system");
  } else {
    printk(KERN_INFO "Mounted successfuly");
  }
  ret->d_sb->s_fs_info = kmalloc(strlen(token) + 1, GFP_KERNEL);
  if (ret->d_sb->s_fs_info == NULL) {
    return NULL;
  }
  strcpy(ret->d_sb->s_fs_info, token);
  return ret;
}

void networkfs_kill_sb(struct super_block *sb) {
  kfree(sb->s_fs_info);
  printk(KERN_INFO
         "networkfs super block is destroyed. Unmount successfully.\n");
}

struct file_system_type networkfs_fs_type = {.name = "networkfs",
                                             .mount = networkfs_mount,
                                             .kill_sb = networkfs_kill_sb};

int networkfs_init(void) { return register_filesystem(&networkfs_fs_type); }

void networkfs_exit(void) { unregister_filesystem(&networkfs_fs_type); }

module_init(networkfs_init);
module_exit(networkfs_exit);
