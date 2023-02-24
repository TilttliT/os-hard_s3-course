#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int readWithLogInf(int fd, char *buf, int msg_size) {
  int n;
  int cnt = 0;
  while (cnt + (n = read(fd, buf + cnt, sizeof(buf) - cnt)) < msg_size) {
    if (n < 0) {
      return 2;
    }
    cnt += n;
  }
  if (cnt + n > msg_size || buf[msg_size - 1] != '\0') {
    return 2;
  }

  printf("%d: got %s\n", getpid(), buf);

  return 0;
}

int main(int argc, char *argv[]) {
  int id;
  int fd1[2], fd2[2];
  int MSG_SIZE1 = 5, MSG_SIZE2 = 5;
  char msg1[] = "ping";
  char msg2[] = "pong";
  char buf[8];

  if (pipe(fd1) || pipe(fd2)) {
    exit(3);
  }
  if ((id = fork()) > 0) {
    // parent
    if (write(fd1[1], msg1, sizeof(msg1)) != sizeof(msg1)) {
      exit(1);
    }
    if (readWithLogInf(fd2[0], buf, MSG_SIZE2)) {
      exit(2);
    }
  } else if (id == 0) {
    // child
    if (readWithLogInf(fd1[0], buf, MSG_SIZE1)) {
      exit(2);
    }
    if (write(fd2[1], msg2, sizeof(msg2)) != sizeof(msg2)) {
      exit(1);
    }
  } else {
    exit(4);
  }

  exit(0);
}
