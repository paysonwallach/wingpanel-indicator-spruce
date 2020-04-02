/*
 * Spruce
 *
 * Copyright © 2020 Payson Wallach
 *
 * Released under the terms of the GNU General Public License, version 3
 * (https://gnu.org/licenses/gpl.html)
 */

namespace Spruce {
    public class Indicator.DBusClient : Object {
        public DBusInterface? interface = null;

        public DBusClient () throws Error {
            try {
                interface = Bus.get_proxy_sync (
                    BusType.SESSION,
                    Config.DBUS_NAME,
                    Config.DBUS_PATH
                );
            } catch (IOError error) {
                throw new Error (error.message);
            }
        }
    }
}
