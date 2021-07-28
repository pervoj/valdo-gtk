[GtkTemplate (ui = "/cz/pervoj/valdo-gtk/list-item.glade")]
class ValdoGTK.ListItem : Gtk.Box {
	[GtkChild] private unowned Gtk.Label title_label;
	[GtkChild] private unowned Gtk.Label subtitle_label;

	private string item_title;
	private string item_subtitle;

	public ListItem (owned string title, owned string subtitle) {
		this.item_title = title;
		title_label.set_text (title);
		this.item_subtitle = subtitle;
		subtitle_label.set_text (subtitle);
	}
}
