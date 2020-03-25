/*
 * Spruce
 *
 * Copyright © 2020 Payson Wallach
 *
 * Released under the terms of the GNU General Public License, version 3
 * (https://gnu.org/licenses/gpl.html)
 */

namespace Spruce {
    public class Plugin : Gala.Plugin {
        private Gala.WindowManager? window_manager = null;
        private Meta.Display? display = null;

        DBusServer dbus_server;

        uint owner_id = 0U;

        public override void initialize (Gala.WindowManager window_manager) {
            this.window_manager = window_manager;
            this.display = window_manager.get_screen ().get_display ();
            this.dbus_server = new DBusServer ();

            var settings = new GLib.Settings (Config.SETTINGS_SCHEMA);

            this.display.add_keybinding (binding, settings, Meta.KeyBindingFlags.NONE, (Meta.KeyHandlerFunc) handler);

            if (owner_id != 0U) {
                return;
            }

            owner_id = Bus.own_name (BusType.SESSION, "com.paysonwallach.spruce", BusNameOwnerFlags.REPLACE,
                (connection) => {
                    try {
                        connection.register_object ("/com/paysonwallach/spruce", dbus_server);
                    } catch (Error error) {
                        warning ("Registering server failed: %s", error.message ());
                        destroy ();
                    }
                },
                () => {},
                (connection, name) => {
                    warning ("Could not acquire bus %s", name);
                    destroy ();
                });
        }

        public override void destroy () {
            if (this.window_manager == null) {
                return;
            }

            this.display.remove_keybinding (binding);
        }

        private Meta.WindowActor? get_active_window_actor () {
            unowned List<Meta.WindowActor> windows = this.display.get_window_actors ();

            var mut_windows = windows.copy ();

            mut_windows.reverse ();

            weak Meta.WindowActor? active = null;

            mut_windows.@foreach ((actor) => {
                if (active != null) {
                    return;
                }

                var window = actor.get_meta_window ();

                if (!actor.is_destoryed () && !window.is_hidden () &&
                        !window.is_skip_taskbar () && window.has_focus ()) {
                    active = actor;
                }
            });

            return active;
        }
    }
}

public Gala.PluginInfo register_plugin () {
    return Gala.PluginInfo () {
        name = Config.NAME,
        author = Config.AUTHOR,
        plugin_type = typeof (Spruce.Plugin),
        provides = Gala.PluginFunction.ADDITION,
        load_priority = Gala.LoadPriority.DEFERRED,
    }
}
