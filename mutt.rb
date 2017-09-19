class Mutt < Formula
  desc "Mongrel of mail user agents (part elm, pine, mush, mh, etc.)"
  homepage 'http://www.mutt.org/'
  url 'https://mirrors.kernel.org/debian/pool/main/m/mutt/mutt_1.5.23.orig.tar.gz'
  mirror 'https://mirrors.ocf.berkeley.edu/debian/pool/main/m/mutt/mutt_1.5.23.orig.tar.gz'
  sha256 "3af0701e57b9e1880ed3a0dee34498a228939e854a16cdccd24e5e502626fd37"
  revision 2

  bottle do
    rebuild 3
    sha256 "7dcb549c1a9efc7f4c1a0602709478cae6f071215a762c77b4d9fba1ab561287" => :yosemite
    sha256 "4b9b8c3a3b069d6103f650f1136161d41de1bc6014a682b6c15fd8d562cc773b" => :mavericks
    sha256 "79b84411d1f0916e7df520b9fbac9f9d4479a4631f5da6b616f363fd6f68d0c2" => :mountain_lion
  end

  head do
    url 'http://dev.mutt.org/hg/mutt#default', :using => :hg

    resource 'html' do
      url 'http://dev.mutt.org/doc/manual.html', :using => :nounzip
    end
  end

  #unless Tab.for_name('signing-party').with? 'rename-pgpring'
  #  conflicts_with 'signing-party',
  #    :because => 'mutt installs a private copy of pgpring'
  #end

  conflicts_with 'tin',
    :because => 'both install mmdf.5 and mbox.5 man pages'

  option "with-debug", "Build with debug option enabled"
  option "with-trash-patch", "Apply trash folder patch"
  option "with-sidebar-patch", "Apply sidebar patch"
  option "with-s-lang", "Build against slang instead of ncurses"
  option "with-ignore-thread-patch", "Apply ignore-thread patch"
  option "with-confirm-attachment-patch", "Apply confirm attachment patch"
  option "with-ssl-client-certificate-without-smtp-authentication-patch", "Apply the ssl-client-certificate-without-smtp-authentication patch"

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  depends_on 'openssl'
  depends_on 'tokyo-cabinet'
  depends_on 's-lang' => :optional
  depends_on 'gpgme' => :optional

  patch do
    url "ftp://ftp.openbsd.org/pub/OpenBSD/distfiles/mutt/trashfolder-1.5.22.diff0.gz"
    sha256 "ce964144264a7d4f121e7a2692b1ea92ebea5f03089bfff6961d485f3339c3b8"
  end if build.with? "trash-patch"

  patch do
    url "https://raw.github.com/nedos/mutt-sidebar-patch/7ba0d8db829fe54c4940a7471ac2ebc2283ecb15/mutt-sidebar.patch"
    sha256 "de592f9eeae458cac8de15a22230b3b426da71a62369617030a84787ccb08712"
  end if build.with? "sidebar-patch"

  # original source for this went missing, patch sourced from Arch at
  # https://aur.archlinux.org/packages/mutt-ignore-thread/
  patch do
    url "https://gist.githubusercontent.com/mistydemeo/5522742/raw/1439cc157ab673dc8061784829eea267cd736624/ignore-thread-1.5.21.patch"
    sha256 "7290e2a5ac12cbf89d615efa38c1ada3b454cb642ecaf520c26e47e7a1c926be"
  end if build.with? "ignore-thread-patch"

  patch do
    url "https://gist.githubusercontent.com/tlvince/5741641/raw/c926ca307dc97727c2bd88a84dcb0d7ac3bb4bf5/mutt-attach.patch"
    sha256 "da2c9e54a5426019b84837faef18cc51e174108f07dc7ec15968ca732880cb14"
  end if build.with? "confirm-attachment-patch"

  patch do
    url "https://raw.githubusercontent.com/fstab/homebrew-mutt/master/ssl-client-certificate-without-smtp-authentication.patch"
    sha256 "4a76f04fa32d483deb05dff5f0153f29f7cf6c3b99480356587c8a75267b1536"
  end if build.with? "ssl-client-certificate-without-smtp-authentication-patch"

  def install
    args = ["--disable-dependency-tracking",
            "--disable-warnings",
            "--prefix=#{prefix}",
            "--with-ssl=#{Formula['openssl'].opt_prefix}",
            "--with-sasl",
            "--with-gss",
            "--enable-imap",
            "--enable-smtp",
            "--enable-pop",
            "--enable-hcache",
            "--with-tokyocabinet",
            # This is just a trick to keep 'make install' from trying to chgrp
            # the mutt_dotlock file (which we can't do if we're running as an
            # unpriviledged user)
            "--with-homespool=.mbox"]
    args << "--with-slang" if build.with? 's-lang'
    args << "--enable-gpgme" if build.with? 'gpgme'

    if build.with? 'debug'
      args << "--enable-debug"
    else
      args << "--disable-debug"
    end


    system "./prepare", *args
    system "make"
    system "make", "install"

    doc.install resource("html") if build.head?
  end

  test do
    system bin/"mutt", "-D"
  end
end
