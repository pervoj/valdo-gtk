[GtkTemplate (ui = "/cz/pervoj/valdo-gtk/page-list-latest-projects.glade")]
class ValdoGTK.ProjectsPage : Gtk.ScrolledWindow {
	[GtkChild] private unowned Gtk.EventBox list_parent;

	// Variables for changing state of other components
	private Gtk.Window parent_window;

	private Settings settings_projects = new Settings ("cz.pervoj.valdo-gtk.projects");
	private Settings settings_preferences = new Settings ("cz.pervoj.valdo-gtk.preferences");

	public ProjectsPage (Gtk.Window parent_window) {
		this.parent_window = parent_window;

		// FIXME: GetText should already be initialized
		Intl.setlocale (LocaleCategory.ALL, "");
		Intl.bindtextdomain (ValdoGTK.Config.GETTEXT_PACKAGE, ValdoGTK.Config.LOCALEDIR);
		Intl.bind_textdomain_codeset (ValdoGTK.Config.GETTEXT_PACKAGE, "UTF-8");
		Intl.textdomain (ValdoGTK.Config.GETTEXT_PACKAGE);

		update_list ();
	}

	public void update_list () { // Load project list from GSettings
		var projects = new HashTable<string, string> (GLib.str_hash, GLib.str_equal);	
		var projects_variant = settings_projects.get_value ("latest-projects");
		var projects_iter = new VariantIter (projects_variant);
		string? project_name = null;
		string? project_path = null;
		while (projects_iter.next ("(ss)", out project_name, out project_path)) {
			projects[project_path] = project_name;
		}

		if (list_parent.get_child () != null) {
			list_parent.get_child ().destroy ();
		}

		if (projects.length > 0) {
			var latest_project_list = new Gtk.ListBox ();

			foreach (unowned var one_project_path in projects.get_keys_as_array ()) {
				var row = new Gtk.ListBoxRow ();
				var eventbox = new Gtk.EventBox ();
				eventbox.add (new ListItem (projects[one_project_path], one_project_path));
				row.add (eventbox);

				row.activate.connect (() => { open_project (one_project_path); });

				row.button_release_event.connect ((event) => {
					if (event.button == 1) { row.activate (); }
					else if (event.button == 3) { remove_project (projects[one_project_path], one_project_path); }
					return false;
				});

				latest_project_list.add (row);
			}

			list_parent.add (latest_project_list);
			latest_project_list.show_all ();
		} else {
			var builder = new Gtk.Builder.from_resource ("/cz/pervoj/valdo-gtk/no-projects.glade");
			var image = builder.get_object ("icon") as Gtk.Image;
			assert (image != null);
			image.icon_name = Config.ICON_NAME;
			var box = builder.get_object ("no-projects") as Gtk.Box;
			assert (box != null);
			list_parent.add (box);
		}
	}

	private void open_project (string project_path) {
		if (settings_preferences.get_boolean ("opening-enable")) {
			var command = settings_preferences.get_string ("opening-command").replace ("{path}", (!)project_path);
			try {
				AppInfo appinfo = AppInfo.create_from_commandline (command, command.split (" ")[0], AppInfoCreateFlags.NONE);
				appinfo.launch (null, null);
			} catch (Error e) {
				show_error_dialog (_("Error opening project: %s").printf (e.message));
			}
		}
	}

	private void remove_project (string project_name, string project_path) {
		var dialog = new Gtk.MessageDialog (parent_window, Gtk.DialogFlags.DESTROY_WITH_PARENT|Gtk.DialogFlags.MODAL, Gtk.MessageType.QUESTION, Gtk.ButtonsType.YES_NO,
			_("Do you really want to remove project %s?").printf (project_name));
		var response = dialog.run ();
		dialog.destroy ();

		if (response == Gtk.ResponseType.YES) {
			var projects = new HashTable<string, string> (GLib.str_hash, GLib.str_equal);
			var projects_variant = settings_projects.get_value ("latest-projects");
			var projects_iter = new VariantIter (projects_variant);
			string? iterated_project_name = null;
			string? iterated_project_path = null;
			while (projects_iter.next ("(ss)", out iterated_project_name, out iterated_project_path)) {
				projects[iterated_project_path] = iterated_project_name;
			}
			projects.remove (project_path);

			VariantBuilder vb = new VariantBuilder (new VariantType ("a(ss)"));
			foreach (unowned var one_project_path in projects.get_keys_as_array ()) {
				vb.add ("(ss)", projects[one_project_path], one_project_path);
			}
			settings_projects.set_value ("latest-projects", vb.end ());

			update_list ();
		}
	}

	private void show_error_dialog (string str) {
		var dialog = new Gtk.MessageDialog (parent_window, Gtk.DialogFlags.DESTROY_WITH_PARENT|Gtk.DialogFlags.MODAL, Gtk.MessageType.ERROR, Gtk.ButtonsType.OK, str);
		dialog.run ();
		dialog.destroy ();
	}
}
