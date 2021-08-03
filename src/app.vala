class ValdoGTK.App : Gtk.Application {
	public App () {
		Object (application_id: Config.APPLICATION_ID,
				flags: ApplicationFlags.FLAGS_NONE);
	}

	public override void startup () {
		base.startup ();
		Environment.set_application_name (_("Valdo GTK"));

		Gtk.Settings? gtk_settings = Gtk.Settings.get_default ();
		assert (gtk_settings != null);
		gtk_settings.gtk_application_prefer_dark_theme = true;


		// Set keyboard shortcuts

		var about_action = new SimpleAction ("about", null);
		about_action.activate.connect (this.show_about_dialog);
		this.set_accels_for_action ("app.about", { "<Primary>I" });
		this.add_action (about_action);

		var quit_action = new SimpleAction ("quit", null);
		quit_action.activate.connect (this.quit);
		this.set_accels_for_action ("app.quit", { "<Primary>Q" });
		this.add_action (quit_action);

		
		new MainWindow (this);
	}

	public override void activate () requires (this.active_window != null) {
		this.active_window.show_all ();
	}

	public void show_about_dialog () requires (this.active_window != null) {
		var about_dialog = new Gtk.AboutDialog () {
			transient_for = this.active_window,
			modal = true,
			destroy_with_parent = true,
			program_name = _("Valdo GTK"),
			comments = _("Create new Vala projects from templates"),
			copyright = _("Copyright \xc2\xa9 2021 Vojtěch Perník"),
			version = Config.VERSION,
			logo_icon_name = Config.ICON_NAME,
			license_type = Gtk.License.GPL_3_0,
			authors = { "Vojtěch Perník <develop@pervoj.cz>" },
			// Translators: Here write your names, or leave it empty. Each name on new line. You can also add email (John Doe <j.doe@example.com>). Do not translate literally!
			translator_credits = _("translator-credits"),
			website = "https://github.com/pervoj/valdo-gtk",
			website_label = _("GitHub repository")
		};
		about_dialog.show_all ();
	}
}

int main(string[] args) {
	// Set app localization
	// https://developer.gnome.org/glib/stable/glib-I18N.html#glib-I18N.description
	Intl.setlocale (LocaleCategory.ALL, "");
	Intl.bindtextdomain (ValdoGTK.Config.GETTEXT_PACKAGE, ValdoGTK.Config.LOCALEDIR);
	Intl.bind_textdomain_codeset (ValdoGTK.Config.GETTEXT_PACKAGE, "UTF-8");
	Intl.textdomain (ValdoGTK.Config.GETTEXT_PACKAGE);

	return new ValdoGTK.App ().run (args);
}
