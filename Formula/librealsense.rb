class Librealsense < Formula
  desc "Intel RealSense D400 series and SR300 capture"
  homepage "https://github.com/IntelRealSense/librealsense"
  url "https://github.com/IntelRealSense/librealsense/archive/v2.16.1.tar.gz"
  sha256 "001787d51398160a4b9285ffa74df08e22615a8278a3c994fc55c1584644584a"
  head "https://github.com/IntelRealSense/librealsense.git"

  bottle do
    cellar :any
    sha256 "716fc703a92a34d2393b5d4f3c3b8fe97cfc4622f1f14945d57be42b200c1c24" => :mojave
    sha256 "1fc81c27816289ad4d9acf6631a376c1838a3f3a0f5c75d5c350f58b60a12f1a" => :high_sierra
    sha256 "02b767b5259a7b381b8f4388c762d0b35fba1fb1816b7632f422d708b93012e4" => :sierra
    sha256 "445caed7e761e5d5d03c76cb48820118021a4313db61cf5b2594a122c714ba7b" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "glfw"
  depends_on "libusb"

  def install
    args = std_cmake_args
    args << "-DENABLE_CCACHE=OFF"

    system "cmake", ".", "-DBUILD_WITH_OPENMP=OFF", *args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <librealsense2/rs.h>
      #include <stdio.h>
      int main()
      {
        printf(RS2_API_VERSION_STR);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-o", "test"
    assert_equal version.to_s, shell_output("./test").strip
  end
end
