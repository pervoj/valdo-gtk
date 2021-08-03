[GtkTemplate (ui = "/cz/pervoj/valdo-gtk/page-list-available-templates.glade")]
class ValdoGTK.TemplatesPage : Gtk.ScrolledWindow {
	[GtkChild] private unowned Gtk.ListBox template_list;

	// Variables for changing state of other components
	private Gtk.Window parent_window;
	private Gtk.Stack parent_stack;
	private VariablesPage variables_page;

	public TemplatesPage (Gtk.Window parent_window, Gtk.Stack parent_stack, VariablesPage variables_page) {
		this.parent_window = parent_window;
		this.parent_stack = parent_stack;
		this.variables_page = variables_page;

		var templates_dir = File.new_for_path (Config.TEMPLATES);

		// List templates
		try {
			var enumerator = templates_dir.enumerate_children (
				FileAttribute.ID_FILE,
				FileQueryInfoFlags.NOFOLLOW_SYMLINKS);
	
			var errors = new Array<Error> ();
			FileInfo? finfo = null;
			while ((finfo = enumerator.next_file ()) != null) {
				unowned var template_dir_name = /* FIXME: non-null */ ((!)finfo).get_name ();
				try {
					var template_name = template_dir_name; // Not working if use directly template_dir_name
					var template = Valdo.Template.new_from_directory (File.new_build_filename (Config.TEMPLATES, template_name));
					
					var row = new Gtk.ListBoxRow ();
					var eventbox = new Gtk.EventBox ();
					eventbox.add (new ListItem (template_name, template.description));
					row.add (eventbox);

					row.activate.connect (() => { open_template (template_name, template); });

					row.button_release_event.connect ((event) => {
						if (event.button == 1) { row.activate (); }
						return false;
					});

					template_list.add (row);
				} catch (Error e) {
					errors.append_val (e);
				}
			}

			for (var i = 0; i < errors.length; i++)
				show_error_dialog (_("Error: %s").printf (errors.index (i).message));
		} catch (Error e) {
			show_error_dialog (_("Error, could not enumerate templates: %s").printf (e.message));
		}
	}

	private void open_template (string template_name, Valdo.Template template) {
		variables_page.generate_list (template_name, template);
		parent_stack.set_visible_child_name ("template-variables");
	}

	private void show_error_dialog (string str) {
		var dialog = new Gtk.MessageDialog (parent_window, Gtk.DialogFlags.DESTROY_WITH_PARENT|Gtk.DialogFlags.MODAL, Gtk.MessageType.ERROR, Gtk.ButtonsType.OK, str);
		dialog.run ();
		dialog.destroy ();
	}
}
