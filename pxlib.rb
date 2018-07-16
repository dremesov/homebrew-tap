require 'formula'

# Documentation: https://github.com/mxcl/homebrew/wiki/Formula-Cookbook
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class Pxlib < Formula
  homepage 'http://sourceforge.net/projects/pxlib/'
  url 'https://ayera.dl.sourceforge.net/project/pxlib/pxlib/0.6.5/pxlib-0.6.5.tar.gz'
  sha256 '2f7a6b77069411d857a1eed75bf9774099c42d35768222314fbeaa5c290a0605'

  depends_on 'cmake' => :build

  def patches
    DATA
  end

  def install
    # ENV.j1  # if your formula's build system can't parallelize

    #system "./configure", "--disable-debug", "--disable-dependency-tracking",
    #                      "--prefix=#{prefix}"
    system "cmake", ".", *std_cmake_args
    system "make" # if this fails, try separate make/make install steps
    lib.install 'libpxlib.dylib'
    include.install 'include/paradox.h'
  end

  def test
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test pxlib`.
    system "false"
  end
end

__END__
diff --git a/CMakeLists.txt b/CMakeLists.txt
index cc1ad00..1320475 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -103,3 +103,5 @@ configure_file(${CMAKE_SOURCE_DIR}/cmakeconfig.h.in ${CMAKE_BINARY_DIR}/config.h
 configure_file(${CMAKE_SOURCE_DIR}/include/paradox.h.in ${CMAKE_BINARY_DIR}/include/paradox.h)
 configure_file(${CMAKE_SOURCE_DIR}/include/paradox-gsf.h.in ${CMAKE_BINARY_DIR}/include/paradox-gsf.h)
 ADD_LIBRARY(pxlib SHARED ${SOURCES})
+target_link_libraries(pxlib iconv)
+

