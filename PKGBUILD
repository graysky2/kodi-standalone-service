# Maintainer: graysky <graysky AT archlinux DOT us>
# Contributor: Sergej Pupykin <pupykin.s+arch@gmail.com>
# Contributor: Brad Fanella <bradfanella@archlinux.us>
# Contributor: [vEX] <niechift.dot.vex.at.gmail.dot.com>
# Contributor: Zeqadious <zeqadious.at.gmail.dot.com>
# Contributor: BlackIkeEagle < ike DOT devolder AT gmail DOT com >
# Contributor: Bartłomiej Piotrowski <bpiotrowski@archlinux.org>
# Contributor: Maxime Gauduin <alucryd@gmail.com>

pkgname=kodi-standalone-service
pkgver=1.7
pkgrel=1
pkgdesc="Systemd service and user to autostart kodi at boot"
arch=('any')
url="https://wiki.archlinux.org/index.php/Kodi#Kodi-standalone-service"
license=('GPL')
depends=('systemd' 'xorg-server' 'xorg-xinit' 'kodi')
replaces=('xbmc-standalone-service')
install=readme.install
source=("https://github.com/graysky2/$pkgname/archive/v$pkgver.tar.gz")
sha256sums=('44a4f1ad4e800bf3973d164b403742b53789e7006ba113ed6b569e3e6353ac70')

package() {
	install -Dm644 "$srcdir/$pkgname-$pkgver/init/kodi.service" \
		"$pkgdir/usr/lib/systemd/system/kodi.service"
	install -dm 700 "$pkgdir"/var/lib/kodi
	chown 420:420 "$pkgdir"/var/lib/kodi
}
