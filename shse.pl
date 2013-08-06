#!/usr/bin/env perl

use strict;
use warnings;
use Tkx;

#Let's just get this out of the way.
#Keep menus from tearing away.
Tkx::option_add("*tearOff", 0);
#Consider this program as proof that 
#OOP does not solve modularity problems.
#Or gratuitous code commenting.

#Elements
#Container
my $mw = Tkx::widget->new(".");
$mw->g_wm_title("shse");
my $content = $mw->new_ttk__frame;
my $frame = $content->new_ttk__frame(-width => 550, -height => 360);

#Menu
#Toplevel
my $menu = $frame->new_menu;
my $filemenu = $menu->new_menu;
my $editmenu = $menu->new_menu;
my $helpmenu = $menu->new_menu;
$menu->add_cascade(-menu => $filemenu, -label => "File");
$menu->add_cascade(-menu => $editmenu, -label => "Edit");
$menu->add_cascade(-menu => $helpmenu, -label => "Help");
#File Menu
$filemenu->add_command(-label => "New", -command => sub {new_file()});
$filemenu->add_command(-label => "Open", -command => sub {open_file()});
$filemenu->add_command(-label => "Save", -command => sub {save_file()});
$filemenu->add_command(-label => "Save As...", -command => sub {save_as_file()});
$filemenu->add_separator;
$filemenu->add_command(-label => "Exit", -command => sub {exit_file()});
#Edit Menu
$editmenu->add_command(-label => "Undo", -command => sub {undo_edit()});
$editmenu->add_command(-label => "Redo", -command => sub {redo_edit()});
$editmenu->add_command(-label => "Cut", -command => sub {cut_edit()});
$editmenu->add_command(-label => "Copy", -command => sub {copy_edit()});
$editmenu->add_command(-label => "Paste", -command => sub {paste_edit()});
$editmenu->add_separator;
$editmenu->add_command(-label => "Preferences", -command => sub {preferences_edit()});
#Help Menu. Yes, there is a "better" way to do it. Let's avoid it.
$helpmenu->add_command(-label => "Documentation", -command => sub {documentation_help()});
$helpmenu->add_separator;
$helpmenu->add_command(-label => "About", -command => sub {about_help()});

#Element layout.
$mw->configure(-menu => $menu);
$content->g_grid(-column => 0, -row => 0);
$frame->g_grid(-column => 0, -row => 0);

#Blast off.
Tkx::MainLoop();