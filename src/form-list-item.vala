[GtkTemplate (ui = "/cz/pervoj/valdo-gtk/form-list-item.glade")]
class ValdoGTK.FormListItem : Gtk.Box {
	[GtkChild] private unowned Gtk.Label title_label;

	private string item_title;

	public FormListItem (string title) {
		this.item_title = title;
		title_label.set_text (title);
	}
}
