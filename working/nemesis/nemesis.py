#!/usr/bin/env python3

import gi
gi.require_version('Gtk', '3.0')
from gi.repository import Gtk
import os
from gi.repository.GdkPixbuf import Pixbuf

class MyWindow(Gtk.Window):
    def __init__(self):
        Gtk.Window.__init__(self, title="Nemesis Installer")
        self.set_border_width(6)
        self.set_default_size(700, 500)
        self.windowicon = Gtk.Image()
        self.windowicon.set_from_icon_name('gnome-settings', Gtk.IconSize.MENU)
        self.main_box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=10)
        self.add(self.main_box)
        self.labelbox = Gtk.Box()
        self.mainlabel = Gtk.Label()
        self.mainlabel.set_markup("<big>Nemesis Installer</big>\nInstall Revenge OS to your hardware")
        self.mainimage = Gtk.Image()
        self.mainimage.set_size_request(100, 100)
        self.mainimage.set_from_file('/usr/share/Icons/obr-logo-sm.png')
        self.labelbox.pack_start(self.mainimage, True, True, 0)
        self.labelbox.pack_start(self.mainlabel, True, True, 0)
        self.main_box.pack_start(self.labelbox, True, True, 0)
        self.button_box = Gtk.Box(spacing=10)
        self.main_box.pack_end(self.button_box, True, True, 0)
        
        # Creating Notebook
        self.notebook = Gtk.Notebook(show_tabs=False)
        self.main_box.pack_start(self.notebook, True,True, 0)
        self.nextbutton = Gtk.Button("Next")
        self.nextbutton.connect("clicked", self.next)
        self.button_box.pack_end(self.nextbutton, True, False, 0)
        
        
        # Creating Welcome page
        self.page1 = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=10)
        self.page1.set_border_width(10)
        self.page1.set_homogeneous(20)
        self.welcomelabel = Gtk.Label("Thank you for Choosing to Install\nRevenge OS\n\nThis Application will guide you through\nthe installation process.\n\nClick the 'next' button to get started.")
        self.page1.pack_start(self.welcomelabel, True, True, 0)
        self.welcomeimage = Gtk.Image()
        self.welcomeimage.set_from_file('crosshairs.png')
        self.page1.pack_start(self.welcomeimage, True, True, 0)
        
        
        self.notebook.append_page(self.page1, Gtk.Label('Welcome'))
        
        # page 2
        self.page2 = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=10)
        self.page2.set_border_width(10)
        self.page2.set_homogeneous(20)
        self.partitionlabel = Gtk.Label()
        self.partitionlabel.set_markup("<big>Partitioning</big>\nHow would you like to partition your disk?")
        self.page2.pack_start(self.partitionlabel, True, True, 0)
        self.page2box = Gtk.Box()
        self.page2.pack_start(self.page2box, True, True, 0)
        self.listpartslabel = Gtk.Label("To List Available Partitions Click")
        self.listpartsbutton = Gtk.Button("Here")
        self.listpartsbutton.connect("clicked", self.disks)
        self.page2box.pack_start(self.listpartslabel, True, True, 0)
        self.page2box.pack_start(self.listpartsbutton, True, True, 0)
        self.autopartbox = Gtk.Box()
        self.page2.pack_start(self.autopartbox, True, True, 0)
        self.autopartlabel = Gtk.Label("To Select Auto-Partitioning, Click")
        self.autopartbox.pack_start(self.autopartlabel, True, True, 0)
        self.autopartbutton = Gtk.Button("Here")
        self.autopartbutton.connect("clicked", self.autopart,)
        self.autopartbox.pack_start(self.autopartbutton, True, True, 0)
        self.replacepartbox = Gtk.Box()
        self.page2.pack_start(self.replacepartbox, True, True, 0)
        self.replacepartlabel = Gtk.Label("To Replace an Existing Partition, Click")
        self.replacepartbox.pack_start(self.replacepartlabel, True, True, 0)
        self.replacepartbutton = Gtk.Button("Here")
        self.replacepartbutton.connect("clicked", self.replacepart,)
        self.replacepartbox.pack_start(self.replacepartbutton, True, True, 0)
        #self.partimage = Gtk.Image()
        #self.partimage.set_from_file('screenshot.png')
        #self.page2.pack_start(self.partimage, True, True, 0)
        self.notebook.append_page(self.page2, Gtk.Label("Partition"))
        
        
    def next(self, widget):
        self.notebook.next_page()
        
    def disks(self, widget):
        os.system("lsblk | zenity --title=Nemesis --text-info --height 400 --width 530")
        
    def autopart(self, widget):
        os.system("./autopart.sh")
        
    def replacepart(self, widget):
        os.system("./replacepart.sh")
    
    
    
    
    
    
    
    
    
    
    
    
win = MyWindow()
win.connect("delete-event", Gtk.main_quit)
win.show_all()
Gtk.main()
