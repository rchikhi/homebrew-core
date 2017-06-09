class Liboping < Formula
  desc "C library to generate ICMP echo requests"
  homepage "https://noping.cc/"
  url "https://noping.cc/files/liboping-1.10.0.tar.bz2"
  sha256 "eb38aa93f93e8ab282d97e2582fbaea88b3f889a08cbc9dbf20059c3779d5cd8"

  bottle do
    sha256 "42b80e23afe4fb4f296d039b0bdd4ccd0da21937514fdd04a90bc01d39da7aec" => :sierra
    sha256 "de0bb72a0752469b262db3a24a41c84746930858462cd08993c057caadd46264" => :el_capitan
    sha256 "c4f46d01bdace450a49e2c4fc4ba4056070bf1b869ed07f1b0a1d6a4f7646bc9" => :yosemite
    sha256 "c85669755c8afdc54ec31e0ba30e49589c84cd0ed2ad2b0988e97135d5381fc1" => :x86_64_linux
  end

  depends_on "ncurses" unless OS.mac?

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  def caveats
    "Run oping and noping sudo'ed in order to avoid the 'Operation not permitted'"
  end

  test do
    system bin/"oping", "-h"
    system bin/"noping", "-h"
  end
end
