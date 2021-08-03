[GtkTemplate (ui = "/cz/pervoj/valdo-gtk/main-window.glade")]
class ValdoGTK.MainWindow : Gtk.ApplicationWindow {
	[GtkChild] private unowned Gtk.Stack pages_stack;

	[GtkChild] private unowned Gtk.Image add_back_button_image;

	[GtkChild] private unowned Gtk.ModelButton about_button;
	[GtkChild] private unowned Gtk.ModelButton quit_button;

	public MainWindow (ValdoGTK.App app) {
		Object (application: app);

		about_button.clicked.connect (app.show_about_dialog);
		quit_button.clicked.connect (app.quit);

		var projects_page = new ProjectsPage (this);
		var variables_page = new VariablesPage (this, pages_stack, projects_page);
		var templates_page = new TemplatesPage (this, pages_stack, variables_page);
		var success_page = new SuccessPage ();

		pages_stack.add_named (projects_page, "latest-projects");
		pages_stack.add_named (templates_page, "available-templates");
		pages_stack.add_named (variables_page, "template-variables");
		pages_stack.add_named (success_page, "creating-success");
		pages_stack.set_visible_child_name ("latest-projects");
		pages_stack.set_transition_type (Gtk.StackTransitionType.SLIDE_LEFT_RIGHT);
	}

	[GtkCallback]
	private void open_preferences () {
		var preferences = new PreferencesWindow (this);
		preferences.show_all ();
	}

	[GtkCallback]
	private void add_back_clicked () {
		switch (pages_stack.get_visible_child_name ()) {
			case "latest-projects":
			case "template-variables":
				pages_stack.set_visible_child_name ("available-templates");
				break;
			default:
				pages_stack.set_visible_child_name ("latest-projects");
				break;
		}

		if (pages_stack.get_visible_child_name () == "latest-projects") {
			add_back_button_image.set_from_icon_name ("list-add-symbolic", Gtk.IconSize.SMALL_TOOLBAR);
		} else {
			add_back_button_image.set_from_icon_name ("go-previous-symbolic", Gtk.IconSize.SMALL_TOOLBAR);
		}
	}
}
