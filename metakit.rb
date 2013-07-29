require 'formula'

class Metakit < Formula
  url 'http://equi4.com/pub/mk/metakit-2.4.9.7.tar.gz'
  homepage 'http://equi4.com/metakit/'
  md5 '17330257376eea657827ed632ea62c9e'

  def install
    Dir.chdir "builds"
    system "../unix/configure", "--disable-debug", "--disable-dependency-tracking",
                          	"--prefix=#{prefix}"
    system "make install"
  end
end
