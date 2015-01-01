# Maintainer: graysky <graysky AT archlinux DOT us>
# Contributor: Sergej Pupykin <pupykin.s+arch@gmail.com>
# Contributor: Brad Fanella <bradfanella@archlinux.us>
# Contributor: [vEX] <niechift.dot.vex.at.gmail.dot.com>
# Contributor: Zeqadious <zeqadious.at.gmail.dot.com>
# Contributor: BlackIkeEagle < ike DOT devolder AT gmail DOT com >
# Contributor: Bartłomiej Piotrowski <bpiotrowski@archlinux.org>
# Contributor: Maxime Gauduin <alucryd@gmail.com>

pkgname=kodi-standalone-service
pkgver=1.5
pkgrel=2
pkgdesc="Systemd service and user to autostart kodi at boot"
arch=('any')
url="https://wiki.archlinux.org/index.php/Xbmc#Autostarting_at_boot"
license=('GPL')
depends=('systemd' 'xorg-server' 'xorg-xinit' 'kodi')
replaces=('xbmc-standalone-service')
install=readme.install
source=("https://github.com/graysky2/$pkgname/archive/v$pkgver.tar.gz")
sha256sums=('10d3077b99d9a2511c3fc38e3ce73436d9de05c765ea4c9c44ca7b8bcd607f85')

package() {
	install -Dm644 "$srcdir/$pkgname-$pkgver/init/kodi.service" "$pkgdir/usr/lib/systemd/system/kodi.service"
	install -Dm755 "$srcdir/$pkgname-$pkgver/common/kodi-standalone2" "$pkgdir/usr/bin/kodi-standalone2"

	install -dm 700 "$pkgdir"/var/lib/kodi
	chown 420:420 "$pkgdir"/var/lib/kodi
}
