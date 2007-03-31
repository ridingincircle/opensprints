require 'controllers/sprint_sensor'
require 'rubygems'
require 'models/racer'
require 'builder'
require 'gtkmozembed'
require 'units/standard'
require 'controllers/dashboard_controller'
require 'rsvg2'
require 'gtk2'

RED_TRACK_LENGTH = 1315
BLUE_TRACK_LENGTH = 1200
RED_WHEEL_CIRCUMFERENCE = 2097.mm.to_km
BLUE_WHEEL_CIRCUMFERENCE = 2097.mm.to_km

@w = Gtk::Window.new
@w.title = "IRO Sprints"
@w.resize(760, 570)
box = Gtk::VBox.new(false, 0)
rpb = RSVG::Handle.new_from_data('<svg></svg>')
gi = Gtk::Image.new(rpb.pixbuf)
dashboard_controller = DashboardController.new
countdown = 2
Gtk.timeout_add(1000) do
  case countdown
  when (1..6)
    gi.pixbuf=dashboard_controller.count(countdown)
    countdown-=1
    true
  when 0
    dashboard_controller.begin_logging
    Gtk.timeout_add(100) do
      gi.pixbuf=dashboard_controller.refresh
      dashboard_controller.continue?
    end
    false    
  end
end
@w.signal_connect("destroy") do
  Gtk.main_quit
end
box.pack_start(gi)
@w << box
@w.show_all
Gtk.main