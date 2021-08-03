[GtkTemplate (ui = "/cz/pervoj/valdo-gtk/preferences-window.glade")]
class ValdoGTK.PreferencesWindow : Gtk.Window {
    private Settings settings_preferences = new Settings ("cz.pervoj.valdo-gtk.preferences");

	[GtkChild] private unowned Gtk.Switch opening_enable_switch;

	[GtkChild] private unowned Gtk.Label opening_command_label;
	[GtkChild] private unowned Gtk.Entry opening_command_entry;

	public PreferencesWindow (Gtk.Window parent) {
        Object (transient_for: parent);

		bool opening_enable = settings_preferences.get_boolean ("opening-enable");
        string opening_command = settings_preferences.get_string ("opening-command");

        opening_enable_switch.set_active (opening_enable);
        switch_clicked (opening_enable);

        opening_command_entry.set_text (opening_command);
	}

    [GtkCallback]
    private bool close_clicked (Gdk.EventAny event) {
        settings_preferences.set_boolean ("opening-enable", opening_enable_switch.get_active ());
        settings_preferences.set_string ("opening-command", opening_command_entry.get_text ());
        return false;
    }

    [GtkCallback]
    private bool switch_clicked (bool state) {
        opening_command_label.set_sensitive (state);
        opening_command_entry.set_sensitive (state);
        return false;
    }
}
