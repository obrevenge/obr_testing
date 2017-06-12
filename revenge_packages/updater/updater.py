#!/usr/bin/env python3

import gi
gi.require_version('Gtk', '3.0')
from gi.repository import Gtk, GObject
import os
from gi.repository.GdkPixbuf import Pixbuf
import platform

class MyWindow(Gtk.Window):

    def __init__(self):
        Gtk.Window.__init__(self, title="Updater Tool")
        self.set_border_width(6)
        self.set_default_size(600, 300)
        self.main_box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=10)
        self.add(self.main_box)
        
        
        self.barbox = Gtk.Box(spacing=10)
        self.updatedatabasebutton = Gtk.Button("Update Package Databases")
        self.updatedatabasebutton.connect("clicked", self.updatedatabases)
        self.barbox.pack_start(self.updatedatabasebutton, True, False, 0)
        self.updatesbutton = Gtk.Button("Check for Updates")
        self.updatesbutton.connect("clicked", self.checkforupdates)
        self.barbox.pack_start(self.updatesbutton, True, True, 0)
        self.main_box.pack_start(self.barbox, False, True, 0)
        self.aurcheckupdatesbutton = Gtk.Button("Check for Updates\nFrom the AUR")
        self.aurcheckupdatesbutton.connect("clicked", self.aurcheckupdates)
        self.barbox.pack_start(self.aurcheckupdatesbutton, True, True, 0)
        self.checkbothbutton = Gtk.Button("Check for Updates From\nBoth Repos and the AUR")
        self.checkbothbutton.connect("clicked", self.checkupdatesboth)
        self.barbox.pack_start(self.checkbothbutton, True, True, 0)

    def aurcheckupdates(self, widget):
        os.system("./aurcheckupdates.sh")
        
    def updatedatabases(self, widget):
        os.system("gksu ./updatedatabases.sh")
        
    def checkforupdates(self, widget):
        os.system("./checkforupdates.sh")

    def checkupdatesboth(self, widget):
        os.system("./checkboth.sh")
        
        
        
        
        
        
        
win = MyWindow()
win.connect("delete-event", Gtk.main_quit)
win.show_all()
Gtk.main()
