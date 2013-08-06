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
my $frame = $content->new_ttk__frame(-width => 550, -height => 345);

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

#Textbox
my $text = $frame->new_tk__text();
#Scrollbar
my $verticalscrollbar = $frame->new_ttk__scrollbar(-orient => 'vertical', -command => [$text, 'yview']);
$text->configure(-yscrollcommand => [$verticalscrollbar, 'set']);
my $horizontalscrollbar = $frame->new_ttk__scrollbar(-orient => 'horizontal', -command => [$text, 'xview']);
$text->configure(-xscrollcommand => [$horizontalscrollbar, 'set']);
#Statusbar
my $linenum;
my $colnum;
my $statusbar = $content->new_ttk__frame(-width => 550, -height => 15);
my $statusbarlinetext = $statusbar->new_ttk__label(-text => "Line ");
my $statusbarlinevar = $statusbar->new_ttk__label(-textvariable => \$linenum);
my $statusbarcoltext = $statusbar->new_ttk__label(-text => ", Column ");
my $statusbarcolvar = $statusbar->new_ttk__label(-textvariable => \$colnum);

#Element layout.
$mw->configure(-menu => $menu);
$content->g_grid(-column => 0, -row => 0, -sticky => "nesw");
$frame->g_grid(-column => 0, -row => 0, -sticky => "nesw");
$text->g_grid(-column=> 0, -row => 0, -sticky => "nesw");
$verticalscrollbar->g_grid(-column => 1, -row => 0, -sticky => "ns");
$horizontalscrollbar->g_grid(-column => 0, -row => 1, -sticky => "we");
$statusbar->g_grid(-column => 0, -row => 2, -sticky => "we");
$statusbarlinetext->g_grid(-column => 0, -row => 2, -sticky => "w");
$statusbarlinevar->g_grid(-column => 0, -row => 2, -sticky => "w");
$statusbarcoltext->g_grid(-column => 0, -row => 2, -sticky => "w");
$statusbarcolvar->g_grid(-column => 0, -row => 2, -sticky => "w");

$mw->new_ttk__sizegrip->g_grid(-column => 0, -row => 0, -sticky => "se");

#Blast off.
Tkx::MainLoop();