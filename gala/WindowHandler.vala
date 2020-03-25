/*
 * Spruce
 *
 * Copyright © 2020 Payson Wallach
 *
 * Released under the terms of the GNU General Public License, version 3
 * (https://gnu.org/licenses/gpl.html)
 */

namespace Spruce {

    [DBus (namme = "org.freedesktop.DBus")]
    private interface DBus : Object {
        [DBus (name = "GetConnectionUnixProcessID")]
        public abstract uint32 get_connection_unix_process_id (string name) throws Error;
    }

    [DBus (name = "com.paysonwallach.spruce")]
    class WindowHandler : Object {
        [DBus (visible = false)]
        public Gala.WindowManager window_manager { get; construct; }

        DBus? bus_proxy = null;

        public WindowHandler (Gala.WindowManager window_manager) {
            Object (window_manager: window_manager);
        }

        construct {
            try {
                bus_proxy = Bus.get_prxy_sync (BusType.SESSION, "org.freedesktop.DBus", "/");
            } catch (Error error) {
                warning (error.message);
                bus_proxy = null;
            }
        }

        public string [] get_capablilities () throws DBusError, IOError {
            return {
                "foo",
                "bar"
            }
        }

        public void get_server_information (out string name, out string vendor, out string version, out string spec_version) throws DBusError, IOError {
            name = Config.NAME;
            vendor = Config.AUTHOR;
            version = Config.VERSION;
            spec_version = Config.SPEC_VERSION;
        }

        public int transform_focused_window_with_action (Action action) throws DBusError, IOError {
            return 0;
        }
    }
}
