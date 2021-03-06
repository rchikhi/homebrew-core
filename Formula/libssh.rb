class Libssh < Formula
  desc "C library SSHv1/SSHv2 client and server protocols"
  homepage "https://www.libssh.org/"
  url "https://www.libssh.org/files/0.8/libssh-0.8.3.tar.xz"
  sha256 "302f31f606f2368cd3ce77d7a69f7464c18eae176e73e59102e0524401bd29d0"
  head "https://git.libssh.org/projects/libssh.git"

  bottle do
    cellar :any
    sha256 "c0648b49bee60175d268b63c9ad28f786116f03d6fee9048cdcd1820297e4b49" => :mojave
    sha256 "02aedb215c7acd4b1867c7fb4ccbfde392e67add97a48932bd37a0713280f448" => :high_sierra
    sha256 "2a050d117262c7fc27ba43ad410c7bbfa67c0cdcc3b1838fe4251990feb14530" => :sierra
    sha256 "0a407ff812fed22ef8512af1d1b00519446a0b073b0ce4f3e48dff1e2a634db1" => :x86_64_linux
  end

  depends_on "cmake" => :build
  depends_on "openssl"
  unless OS.mac?
    depends_on "python@2" => :build
    depends_on "zlib"
  end

  def install
    mkdir "build" do
      system "cmake", "..", "-DWITH_STATIC_LIB=ON",
                            "-DWITH_SYMBOL_VERSIONING=OFF",
                            *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <libssh/libssh.h>
      #include <stdlib.h>
      int main()
      {
        ssh_session my_ssh_session = ssh_new();
        if (my_ssh_session == NULL)
          exit(-1);
        ssh_free(my_ssh_session);
        return 0;
      }
    EOS
    system ENV.cc, "-I#{include}", *("-L#{lib}" if OS.mac?), *("-lssh" if OS.mac?),
           testpath/"test.c", *("-L#{lib}" unless OS.mac?), *("-lssh" unless OS.mac?), "-o", testpath/"test"
    system "./test"
  end
end
