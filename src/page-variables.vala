[GtkTemplate (ui = "/cz/pervoj/valdo-gtk/page-list-template-variables.glade")]
class ValdoGTK.VariablesPage : Gtk.ScrolledWindow {
	[GtkChild] private unowned Gtk.EventBox list_parent;

	// Variables for changing state of other components
	private Gtk.Window parent_window;
	private Gtk.Stack parent_stack;
	private ProjectsPage projects_page;

	private Settings settings_projects = new Settings ("cz.pervoj.valdo-gtk.projects");

	public HashTable<string, string> substitutions = new HashTable<string, string> (str_hash, str_equal);

	public VariablesPage (Gtk.Window parent_window, Gtk.Stack parent_stack, ProjectsPage projects_page) {
		this.parent_window = parent_window;
		this.parent_stack = parent_stack;
		this.projects_page = projects_page;

		// FIXME: GetText should already be initialized
		Intl.setlocale (LocaleCategory.ALL, "");
		Intl.bindtextdomain (ValdoGTK.Config.GETTEXT_PACKAGE, ValdoGTK.Config.LOCALEDIR);
		Intl.bind_textdomain_codeset (ValdoGTK.Config.GETTEXT_PACKAGE, "UTF-8");
		Intl.textdomain (ValdoGTK.Config.GETTEXT_PACKAGE);
	}

	public void generate_list (string template_name, Valdo.Template template) {
		var variable_list = new Gtk.ListBox (); // Declare new list

		// Add template name to list
		var title_row = new Gtk.ListBoxRow ();
		title_row.set_selectable (false);
		title_row.set_activatable (false);
		title_row.set_can_focus (false);
		title_row.add (new ListItem (_("Template name:"), template_name));
		variable_list.add (title_row);

		// Add project location chooser to list
		var path_item = new FormListItem (_("Project location:"));
		var path_button = new Gtk.FileChooserButton (_("Choose project location"), Gtk.FileChooserAction.SELECT_FOLDER);
		path_item.pack_end (path_button);
		var path_row = new Gtk.ListBoxRow ();
		path_row.set_selectable (false);
		path_row.set_activatable (false);
		path_row.set_can_focus (false);
		path_row.add (path_item);
		variable_list.add (path_row);
		
		// Add variable entries to list
		var entries = new HashTable<string, Gtk.Entry> (GLib.str_hash, GLib.str_equal); 
		for (var i = 0; i < template.variables.length; i++) {
			var variable = template.variables.index (i);

			if (variable.auto && variable.default != null) continue;

			var item = new FormListItem (_("Enter %s:").printf (variable.summary));
			var entry = new Gtk.Entry ();
			entries[variable.name] = entry;

			if (variable.default != null) {
				// setup this entry to receive change events from previous entries
				foreach (unowned var referenced_var in variable.default.referenced_vars) {
					var referenced_entry = entries[referenced_var];

					referenced_entry.bind_property ("text", entry, "text", BindingFlags.SYNC_CREATE, (binding, from, ref to) => {
						substitutions[referenced_var] = from.get_string ();
						to = variable.default.substitute (substitutions);
						return true;
					});
				}

				entry.text = variable.default.substitute (substitutions);
				substitutions[variable.name] = entry.text;
			}

			item.pack_start (entry);

			if (variable.pattern != null && variable.name != "USERADDR") {
				string pattern = /* FIXME: non-null */(!)variable.pattern;
				string? tooltip = null;
				if (pattern.length > 60) {
					tooltip = pattern;
					pattern = pattern[0:60] + "...";
				}
				var pattern_label = get_italic_label (pattern);
				pattern_label.set_tooltip_text (tooltip);
				item.pack_start (pattern_label);
			}
			
			var row = new Gtk.ListBoxRow ();
			row.set_selectable (false);
			row.set_activatable (false);
			row.set_can_focus (false);
			row.add (item);
			variable_list.add (row);
		}

		// Add OK button to list
		var ok_button = new Gtk.Button.with_label (_("Create"));
		ok_button.set_valign (Gtk.Align.CENTER);
		ok_button.set_halign (Gtk.Align.END);
		ok_button.set_border_width (10);
		var ok_row = new Gtk.ListBoxRow ();
		ok_row.set_selectable (false);
		ok_row.set_activatable (false);
		ok_row.set_can_focus (false);
		ok_row.add (ok_button);
		variable_list.add (ok_row);

		
		// Set OK button onclick action
		ok_button.clicked.connect (() => {
			// Check if everything was setted correctly
			bool success = true;
			if (path_button.get_current_folder () == null) {
				success = false;
				show_error_dialog (_("Error: select project location"));
			}
			var substitutions = new HashTable<string, string> (GLib.str_hash, GLib.str_equal);
			if (success) {
				for (var i = 0; i < template.variables.length; i++) {
					var variable = template.variables.index (i);
					var text = entries[variable.name].get_text ();

					if (text == "") {
						success = false;
						show_error_dialog (_("Error: %s was not specified").printf (variable.summary));
						break;
					}

					if (variable.pattern != null) {
						try {
							if (!new Regex (/* FIXME: non-null */(!)variable.pattern).match (/* FIXME: non-null */(!)text)) {
								success = false;
								if (variable.name != "USERADDR") {
									show_error_dialog (_("Error: %s must match the pattern %s").printf (variable.summary, /* FIXME: non-null */(!)variable.pattern));
								} else {
									show_error_dialog (_("Error: %s must be valid email").printf (variable.summary));
								}
								break;
							}
						} catch (Error e) {
							show_error_dialog (_("Regex error: %s").printf (e.message));
						}
					}

					substitutions[variable.name] = text;
				}
			}

			// If everything was setted correctly
			if (success) {
				try {
					// Create files
					Valdo.TemplateEngine.apply_template (
						template,
						path_button.get_current_folder_file (),
						substitutions["PROJECT_DIR"],
						substitutions
					);

					// Add project to list
					add_project_to_schema (substitutions["PROJECT_NAME"], GLib.Path.build_path (GLib.Path.DIR_SEPARATOR_S, path_button.get_current_folder_file ().get_path (), substitutions["PROJECT_DIR"]));
					projects_page.update_list ();

					// Switch to success page
					parent_stack.set_visible_child_name ("creating-success");
				} catch (Error e) {
					show_error_dialog (_("Error creating template: %s").printf (e.message));
				}
			}
		});


		// Add list to page
		if (list_parent.get_child () != null) {
			list_parent.get_child ().destroy ();
		}
		list_parent.add (variable_list);
		variable_list.show_all ();
	}

	private Gtk.Label get_italic_label (string str) {
		var attrs = new Pango.AttrList ();
		attrs.insert (new Pango.AttrFontDesc (Pango.FontDescription.from_string ("Italic")));

		var label = new Gtk.Label (str);
		label.set_attributes (attrs);
		label.set_xalign (0);

		return label;
	}

	private void show_error_dialog (string str) {
		var dialog = new Gtk.MessageDialog (parent_window, Gtk.DialogFlags.DESTROY_WITH_PARENT|Gtk.DialogFlags.MODAL, Gtk.MessageType.ERROR, Gtk.ButtonsType.OK, str);
		dialog.run ();
		dialog.destroy ();
	}

	private void add_project_to_schema (string name, string path) { // Add project list to GSettings
		var projects = new HashTable<string, string> (GLib.str_hash, GLib.str_equal);
		projects[path] = name;
		var projects_variant = settings_projects.get_value ("latest-projects");
		var projects_iter = new VariantIter (projects_variant);
		string? project_name = null;
		string? project_path = null;
		while (projects_iter.next ("(ss)", out project_name, out project_path)) {
			projects[project_path] = project_name;
		}
		
		VariantBuilder vb = new VariantBuilder (new VariantType ("a(ss)"));
		foreach (unowned var one_project_path in projects.get_keys_as_array ()) {
			vb.add ("(ss)", projects[one_project_path], one_project_path);
		}
		settings_projects.set_value ("latest-projects", vb.end ());
	}
}
