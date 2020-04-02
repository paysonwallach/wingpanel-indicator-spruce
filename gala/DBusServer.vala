/*
 * Spruce
 *
 * Copyright © 2020 Payson Wallach
 *
 * Released under the terms of the GNU General Public License, version 3
 * (https://gnu.org/licenses/gpl.html)
 */

namespace Spruce {
    [DBus (name = Config.DBUS_NAME)]
    public class DBusServer : Object {

        public DBusServer () {
            Bus.own_name (
                BusType.SESSION,
                Config.DBUS_NAME,
                BusNameOwnerFlags.NONE,
                (connection) => on_bus_acquired (connection),
                () => {},
                null
            );
        }

        public void on_bus_acquired (DBusConnection connection) {
            try {
                connection.register_object (Config.DBUS_PATH, get_default ());
            } catch (Error error) {
                error (error.message);
            }
        }

        public int transform_focused_window_with_action (Action action) throws IOError, DBusError {
            return 0;
        }
    }
}
