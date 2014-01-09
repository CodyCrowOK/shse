#!/usr/bin/env perl

use strict;
use warnings;
use 5.14.0;
use Tkx;
use IO qw(File);

#Let's just get this out of the way.
#Keep menus from tearing away.
Tkx::option_add("*tearOff", 0);
#Consider this program as proof that 
#OOP does not solve modularity problems.
#Or gratuitous code commenting.

#Let's do some basic file-info hashref fun.
our %newfile = (
	'filename' 	=> 'UNTITLED',
	'contents'	=> '',
	'lang'		=> '',
	'encoding'	=> 'utf-8',
);
#Initialize the current state to a new file.
say "Initializing internal hashref to a new file.";
our $current = \%newfile;


#Elements
#Container
my $framewidth = 550;
my $frameheight = 345;
my $mw = Tkx::widget->new(".");
$mw->g_wm_title($current->{filename} . " - shse");
$mw->g_wm_minsize($framewidth, $frameheight);
my $content = $mw->new_ttk__frame;
my $frame = $content->new_ttk__frame();

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

sub update_current {
	say "Updating \$current hashref.";
	$current->{contents} = $text->get("1.0", "end");
	#Everything else should be updated by other subs,
	#because modularity is for people who can't keep
	#an arbitrarily large number of layers in their heads.
}

sub save {
	###Requires that all relevant details be resolved before being called,
	###Except for the contents of the text field.
	#Obviously save the current open file to disk.
	#Create instance of whatever file.
	say "Update internal hashref.";
	&update_current;
	if ($current->{filename} eq "UNTITLED") { goto-&save_as_file; } #Goto for President
	say "Attempting to save.";
	open(my $fh, ">", $current->{filename}) or warn "Couldn't open for saving: $!";
	say "Opened for saving.";
	print $fh $current->{contents};
	say "Contents written to file.";
	close($fh) or warn "Couldn't close file: $!";
	say "File saved.";
}

sub confirm_save {
	#TODO: Prompt.
	&save;
}

sub exit_file {
	#TODO: Put a save confirmation alert up.
	$mw->g_destroy;
}

sub save_file {
	&save;
}

sub save_as_file {
	$current->{filename} = Tkx::tk___getSaveFile();
	&save;
}

sub new_file {
	&confirm_save;
	$current = \%newfile;
	$text->delete('1.0', 'end'); #clear the way
	$text->insert('1.0', $current->{contents});
	$mw->g_wm_title($current->{filename} . " - shse");
	
}

sub CATCHALL_ERRORS_LOL {
	
}

#Blast off.
Tkx::MainLoop();
