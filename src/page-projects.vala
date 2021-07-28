[GtkTemplate (ui = "/cz/pervoj/valdo-gtk/page-list-latest-projects.glade")]
class ValdoGTK.ProjectsPage : Gtk.ScrolledWindow {
	[GtkChild] private unowned Gtk.EventBox list_parent;

	private Settings settings = new Settings ("cz.pervoj.valdo-gtk");

	public ProjectsPage () {
		update_list ();
	}

	public void update_list () { // Load project list from GSettings
		var latest_project_list = new Gtk.ListBox ();

		var projects_variant = settings.get_value ("latest-projects");
		var projects_iter = new VariantIter (projects_variant);

		string? project_name = null;
		string? project_path = null;

		while (projects_iter.next ("(ss)", out project_name, out project_path)) {
			var row = new Gtk.ListBoxRow ();
			row.add (new ListItem (project_name, project_path));
			latest_project_list.add (row);
		}

		if (list_parent.get_child () != null) {
			list_parent.get_child ().destroy ();
		}
		list_parent.add (latest_project_list);
		latest_project_list.show_all ();
	}
}
