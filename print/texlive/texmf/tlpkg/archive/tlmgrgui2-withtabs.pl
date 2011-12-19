#!/usr/bin/env perl
# $Id: tlmgrgui2.pl 15823 2009-10-18 01:41:28Z preining $
#
# Copyright 2009 Norbert Preining
# This file is licensed under the GNU General Public License version 2
# or any later version.
#
# GUI for tlmgr
# version 2, completely rewritten GUI
#
# TODO: move the check for critical updates from old create_update_list
#       to here!!
# TODO: center checkbuttons vertically
# TODO: double click on one line should pop up a window with tlmgr show info

$^W = 1;
use strict;

use Tk;
use Tk::Dialog;
use Tk::BrowseEntry;
use Tk::ROText;
use Tk::TixGrid;
use TeXLive::Splashscreen;

use TeXLive::TLUtils qw(setup_programs platform_desc win32 debug);
use TeXLive::TLConfig;

our $Master;
our $tlmediatlpdb;
our $tlmediasrc;
our $localtlpdb;

# defined in tlmgr.pl
our $location;

my $tlpdb_location;
my $cmdline_location;
#
our %opts;
#
# the list of packages as shown by TixGrid
#
my %Packages;
our $mw;

sub update_status_box {
  update_status(join(" ", @_));
  $mw->update;
}

sub init_hooks {
  push @::info_hook, \&update_status_box;
  push @::warn_hook, \&update_status_box;
  push @::debug_hook, \&update_status_box;
  push @::ddebug_hook, \&update_status_box;
  push @::dddebug_hook, \&update_status_box;
}

sub update_status {
  my ($p) = @_;
  $::progressw->insert("end", "$p");
  $::progressw->see("end");
}


# prepare for loading of lang.pl which expects $::lang and $::opt_lang
$::opt_lang = $opts{"gui-lang"} if (defined($opts{"gui-lang"}));

require("TeXLive/trans.pl");

our @update_function_list;

$mw = MainWindow->new;
$mw->title("TeX Live Manager $TeXLive::TLConfig::ReleaseYear");
$mw->withdraw;

#
# default layout definitions
#
# priority 20 = widgetDefault 
# see Mastering Perl/Tk, 16.2. Using the Option Database
$mw->optionAdd("*Button.Relief", "ridge", 20);
#
# does not work, makes all buttons exactely 10, which is not a good idea
# I would like to have something like MinWidth 10...
#$mw->optionAdd("*Button.Width", "10", 20);
#
# shortcuts for padding, expand/fill, and pack sides, anchors
my @p_ii = qw/-padx 2m -pady 2m/;
my @p_iii= qw/-padx 3m -pady 3m/;
my @x_x = qw/-expand 1 -fill x/;
my @x_y = qw/-expand 1 -fill y/;
my @x_xy= qw/-expand 1 -fill both/;
my @left = qw/-side left/;
my @right= qw/-side right/;
my @bot  = qw/-side bottom/;
my @a_w = qw/-anchor w/;
my @a_c = qw/-anchor c/;


# create a progress bar window
$::progressw = $mw->Scrolled("ROText", -scrollbars => "e", -height => 4);
$::progressw->pack(-fill => "x", @bot);


my $critical_updates_present = 0;


init_hooks();

info(__("Loading local TeX Live Database\nThis may take some time, please wait!") . "\n");

our $localtlmedia = TeXLive::TLMedia->new ( $Master );
die("cannot setup TLMedia in $Master") unless (defined($localtlmedia));
$localtlpdb = $localtlmedia->tlpdb;
die("cannot find tlpdb!") unless (defined($localtlpdb));

our @main_list;

$tlpdb_location = $localtlpdb->option("location");
if (defined($opts{"location"})) {
  $cmdline_location = $opts{"location"};
}


push @update_function_list, \&check_location_on_ctan;
push @update_function_list, \&init_install_media;

#
# check that we can actually save the database
#
if (check_on_writable()) {
  $::we_can_save = 1;
} else {
  $::we_can_save = 0;
  # here we should pop up a warning window!!!
}
$::action_button_state = ($::we_can_save ? "normal" : "disabled");

my $tlmgrrev = give_version();
chomp($tlmgrrev);

our $top = $mw->Frame;

my $menu = $mw->Menu();
my $menu_file = $menu->Menu();
my $menu_options = $menu->Menu();
my $menu_actions = $menu->Menu();
my $menu_help = $menu->Menu();
$menu->add('cascade', -label => "File", -menu => $menu_file);
$menu->add('cascade', -label => "Options", -menu => $menu_options);
$menu->add('cascade', -label => "Actions", -menu => $menu_actions);
$menu->add('cascade', -label => "Help", -menu => $menu_help);
$menu->add('separator');
$menu->add('command', -label => "Loaded repository: none",
  -command => sub { $location = $tlpdb_location; 
                    update_loaded_location_string();
                    run_update_functions();
                  });
#  -activebackground => $menu->cget(-background));

#
# FILE MENU
#
$menu_file->add('command', -label => "Load default repository: $tlpdb_location",
  -command => sub { 
                     $location = $tlpdb_location; 
                     update_loaded_location_string();
                     run_update_functions(); 
                  });
if (defined($cmdline_location)) {
  $menu_file->add('command', -label => "Load cmd line repository: $cmdline_location",
    -command => sub { 
                      $location = $cmdline_location; 
                      update_loaded_location_string();
                      run_update_functions(); 
                    });
}
$menu_file->add('command', -label => "Load default net repository: $TeXLiveURL",
  -command => sub { 
                     $location = $TeXLiveURL; 
                     update_loaded_location_string();
                     run_update_functions(); 
                  });
$menu_file->add('command', -label => "Load other repository",
  -command => sub { menu_edit_location(); });
$menu_file->add('separator');
$menu_file->add('command', -label => __("Quit"),
                           -command => sub { $mw->destroy; exit(0); });

#
# OPTIONS MENU
#
$menu_options->add('command', -label => __("General settings"),
  -command => sub { do_general_settings(); });
$menu_options->add('command', -label => __("Paper settings"),
  -command => sub { do_paper_settings(); });
$menu_options->add('command', -label => __("Arch settings"),
  -command => sub { do_arch_settings(); });
$menu_options->add('separator');
$menu_options->add('checkbutton', -label => __("Debug"),
  -onvalue => ($::opt_verbosity == 0 ? 1 : $::opt_verbosity),
  -variable => \$::opt_verbosity);

#
# Actions menu
#
$menu_actions->add('command', -label => __("Re-initialize file database"),
  -state => $::action_button_state,
  -command => sub { 
                    $mw->Busy(-recurse => 1);
                    info("Running mktexlsr, this may take some time ...\n");
                    info(`mktexlsr 2>&1`); 
                    $mw->Unbusy;
                  });
$menu_actions->add('command', -label => __("Re-create all formats"),
  -state => $::action_button_state,
  -command => sub { 
                    $mw->Busy(-recurse => 1);
                    info("Running fmtutil-sys --all, this may take some time ...\n");
                    info(`fmtutil-sys --all 2>&1`); 
                    $mw->Unbusy;
                  });
$menu_actions->add('command', -label => __("Update font map database"),
  -state => $::action_button_state,
  -command => sub { 
                    $mw->Busy(-recurse => 1);
                    info("Running updmap-sys, this may take some time ...\n");
                    info(`updmap-sys 2>&1`); 
                    $mw->Unbusy;
                  });

if (!win32()) {
  $menu_actions->add('command', -label => __("Update symbolic links"),
    -state => $::action_button_state,
    -command => sub {
                      $mw->Busy(-recurse => 1);
                      info("Updating symlinks ...\n");
                      execute_action_gui("path", "add");
                      $mw->Unbusy;
                    });
  $menu_actions->add('command', -label => __("Remove symbolic links"),
    -state => $::action_button_state,
    -command => sub {
                      $mw->Busy(-recurse => 1);
                      info("Removing symlinks ...\n");
                      execute_action_gui("path", "remove");
                      $mw->Unbusy;
                    });
}
if (!win32()) {
  $menu_actions->add('separator');
  $menu_actions->add('command', -label => __("Remove TeX Live %s", $TeXLive::TLConfig::ReleaseYear),
    -state => $::action_button_state,
    -command => sub { 
      my $sw = $mw->DialogBox(-title => __("Remove TeX Live %s", $TeXLive::TLConfig::ReleaseYear),
                              -buttons => [ __("Ok"), __("Cancel") ],
                              -cancel_button => __("Cancel"),
                              -command => sub { 
                                my $b = shift;
                                if ($b eq __("Ok")) {
                                  system("tlmgr", "uninstall", "--force");
                                  $mw->Dialog(-text => __("Complete removal completed"), -buttons => [ __("Ok") ])->Show;
                                  $mw->destroy; 
                                  exit(0); 
                                }
                              });
      $sw->add("Label", -text =>  __("Really remove the complete TeX Live %s installation?\nYour last chance to change your mind!", $TeXLive::TLConfig::ReleaseYear))->pack(@p_iii);
      $sw->Show;
    });
}
  


#
# HELP MENU
$menu_help->add('command', -label => __("About"),
  -command => sub {
    my $sw = $mw->DialogBox(-title => __("About"),
                            -buttons => [ __("Ok") ]);
    $sw->add("Label", -text => "TeX Live Manager (GUIv2)
$tlmgrrev
Copyright 2009 Norbert Preining

Licensed under the GNU General Public License version 2 or higher
In case of problems, please contact: texlive\@tug.org"
      )->pack(@p_iii);
    $sw->Show;
    });
 

$mw->configure(-menu => $menu);

our $back_f1 = $mw->Frame();

# pack .top .back -side top -fill both -expand 1
$top->pack(-fill => 'x', @p_ii);
$back_f1->pack(@x_xy);

#require ("do_listframe.pl");

######### SHOULD GO INTO A SEPARTE FILE ########################
# install screen
my $top_frame = $back_f1->Labelframe(-text => "Display configuration");
$top_frame->pack(@x_x, @p_ii);

my $filter_frame = $top_frame->Frame();
$filter_frame->pack;

my $filter_status = $filter_frame->Labelframe(-text => "Status");
$filter_status->pack(@left, @p_ii);

my $status_all = 0;
my $status_only_installed = 1;
my $status_only_not_installed = 2;
my $status_only_updated = 3;
my $status_value = 0;
$filter_status->Radiobutton(-text => "all", 
  -variable => \$status_value, -value => $status_all)->pack(@a_w);
$filter_status->Radiobutton(-text => "only installed", 
  -variable => \$status_value, -value => $status_only_installed)->pack(@a_w);
$filter_status->Radiobutton(-text => "only uninstalled", 
  -variable => \$status_value, -value => $status_only_not_installed)->pack(@a_w);
$filter_status->Radiobutton(-text => "only updated", 
  -variable => \$status_value, -value => $status_only_updated)->pack(@a_w);

my $filter_category = $filter_frame->Labelframe(-text => "Category");
$filter_category->pack(@left, @x_y, @p_ii);
my $show_packages = 1;
my $show_collections = 1;
my $show_schemes = 1;
$filter_category->Checkbutton(-text => "packages", 
   -variable => \$show_packages)->pack(@a_w);
$filter_category->Checkbutton(-text => "collections", 
   -variable => \$show_collections)->pack(@a_w);
$filter_category->Checkbutton(-text => "schemes", 
   -variable => \$show_schemes)->pack(@a_w);

my $filter_match = $filter_frame->Labelframe(-text => "Match");
$filter_match->pack(@left, @x_y, @p_ii);
my $match_all = 1;
$filter_match->Radiobutton(-text => "all", 
        -variable => \$match_all, -value => 1)->pack(@a_w);
$filter_match->Radiobutton(-text => "matching:",
        -variable => \$match_all, -value => 0)->pack(@a_w);
my $match_entry = 
  $filter_match->Entry(-width => 15)->pack(@a_w, -padx => '2m', @x_x);

my $filter_selection = $filter_frame->Labelframe(-text => "Selection");
$filter_selection->pack(@left, @x_y, @p_ii);
my $selection_value = 0;
$filter_selection->Radiobutton(-text => "all", 
                         -variable => \$selection_value, -value => 0)->pack(@a_w);
$filter_selection->Radiobutton(-text => "only selected", 
                         -variable => \$selection_value, -value => 1)->pack(@a_w);
$filter_selection->Radiobutton(-text => "only not selected", 
                         -variable => \$selection_value, -value => 2)->pack(@a_w);


my $filter_button = $filter_frame->Labelframe(-text => "Action");
$filter_button->pack(@left, @x_y, @p_ii);
$filter_button->Button(-text => "Apply filters",
  -command => sub { update_grid(); })->pack(@a_c, @p_ii);
$filter_button->Button(-text => "Reset filters",
  -command => sub { $status_value = $status_all;
                    $show_packages = 1; $show_collections = 1; 
                    $show_schemes = 1;
                    $selection_value = 0;
                    $match_all = 1;
                    update_grid();
                  })->pack(@a_c, @p_ii);

########## Packages #######################
my $list_frame = $back_f1->Labelframe(-text => "Packages");
$list_frame->pack(@x_xy, @p_ii);
my $g = $list_frame->Scrolled('TixGrid', -scrollbars => "se", -bd => 0,
                                      -floatingrows => 0, -floatingcols => 0,
				 -leftmargin => 2, # selection and label
				 -topmargin => 1, # top labels
         -command => \&show_extended_info, # does not work, double click!
				 -selectmode => "none", 
				 -selectunit => "row");

# that does not work, I have no idea what has to be done
#$g->ItemStyle('window', -anchor => "c");

$g->pack(qw/-expand 1 -fill both -padx 3 -pady 3/);
$g->configure(-formatcmd=>[\&AlternatingLineColoring, $g]);
$g->size(qw/col 4 -size 10char/);
$g->size(qw/col 5 -size 10char/);
$g->size(qw/col default -size auto/);
$g->size(qw/row default -size 1.1char -pad0 3/);

setup_list();
update_grid();

sub show_extended_info {
  my ($x, $y) = @_;
  print "double click on $x - $y\n";
}

sub update_grid {
  # fill the header
  #$g->set(0,0, -itemtype => 'window', -widget => $g->Checkbutton());
  $g->set(1,0, -itemtype => 'text', -text => "Package");
  $g->set(2,0, -itemtype => 'text', -text => "Local Rev");
  $g->set(3,0, -itemtype => 'text', -text => "Remote Rev");
  $g->set(4,0, -itemtype => 'text', -text => "Local Ver");
  $g->set(5,0, -itemtype => 'text', -text => "Remote Ver");
  $g->set(6,0, -itemtype => 'text', -text => "Short Desc");

  my @schemes;
  my @colls;
  my @packs;
  for my $p (sort keys %Packages) {
    if ($Packages{$p}{'category'} eq "Scheme") {
      push @schemes, $p;
    } elsif ($Packages{$p}{'category'} eq "Collection") {
      push @colls, $p;
    } else {
      push @packs, $p;
    }
  }
  my $i = 1;
  # the number of current lines:
  my (undef, $curlines) = $g->index(0, 'max');
  for my $p (@schemes, @colls, @packs) {
    if (MatchesFilters($p)) {
      # unset first so that the checkbutton is unmapped, otherwise crashes
      $g->unset(0,$i) if $g->infoExists(0,$i);
      $g->set(0,$i, -itemtype => 'window', 
                    -widget => $Packages{$p}{'cb'});
      #
      $g->set(1,$i, -itemtype => 'text', -text => $Packages{$p}{'displayname'});
      if (defined($Packages{$p}{'localrevision'})) {
        $g->set(2,$i, -itemtype => 'text', -text => $Packages{$p}{'localrevision'});
      } else {
        $g->unset(2,$i);
      }
      if (defined($Packages{$p}{'remoterevision'})) {
        $g->set(3,$i, -itemtype => 'text', -text => $Packages{$p}{'remoterevision'})
      } else {
        $g->unset(3,$i);
      }
      if (defined($Packages{$p}{'localcatalogueversion'})) {
        $g->set(4,$i, -itemtype => 'text', -text => $Packages{$p}{'localcatalogueversion'})
      } else {
        $g->unset(4,$i);
      }
      if (defined($Packages{$p}{'remotecatalogueversion'})) {
        $g->set(5,$i, -itemtype => 'text', -text => $Packages{$p}{'remotecatalogueversion'})
      } else {
        $g->unset(5,$i);
      }
      $g->set(6,$i, -itemtype => 'text', -text => $Packages{$p}{'shortdesc'});
      $i++;
    }
  }
  if ($i <= $curlines) {
    # remove the rest of the lines
    $g->deleteRow($i, $curlines);
  }
}
  
sub MatchesFilters {
  my $p = shift;
  # status
  if (( ($status_value == $status_all) ) ||
      ( ($status_value == $status_only_installed) && 
        (defined($Packages{$p}{'installed'})) && 
        ($Packages{$p}{'installed'} == 1) ) ||
      ( ($status_value == $status_only_not_installed) &&
        ( !defined($Packages{$p}{'installed'}) ||
          ($Packages{$p}{'installed'} == 0)) ) ||
      ( ($status_value == $status_only_updated) &&
        (defined($Packages{$p}{'localrevision'})) &&
        (defined($Packages{$p}{'remoterevision'})) &&
        ($Packages{$p}{'localrevision'} < $Packages{$p}{'remoterevision'}))) {
    # do nothing, more checks have to be done
  } else {
    return 0;
  }
  # category
  if (($show_packages    && ($Packages{$p}{'category'} eq 'Other')) ||
      ($show_collections && ($Packages{$p}{'category'} eq 'Collection')) ||
      ($show_schemes     && ($Packages{$p}{'category'} eq 'Scheme')) ) {
    # do nothing, more checks have to be done
  } else {
    return 0;
  }
  # match
  if (!$match_all) {
    my $r = $match_entry->get;
    # check for match on string
    my $t = $Packages{$p}{'shortdesc'};
    $t |= "";
    my $lt = $Packages{$p}{'longdesc'};
    $lt |= "";
    if (($p =~ m/$r/) || ($t =~ m/$r/) || ($lt =~ m/$r/)) {
      # do nothing, more checks have to be done
    } else {
      return 0;
    }
  }
  # selection
  if ($selection_value == 0) {
    # all -> maybe more checks
  } elsif ($selection_value == 1) {
    # only selected
    if ($Packages{$p}{'selected'}) {
      # do nothing, maybe more checks
    } else {
      # not selected package and only selected packages shown
      return 0;
    }
  } else {
    # only not selected
    if ($Packages{$p}{'selected'}) {
      # selected, but only not selected should be shown
      return 0;
    } # else do nothing
  }
  #
  # if we come down to here the package matches
  return 1;
}


sub AlternatingLineColoring {
  my ($w, $area, @entbox) = @_;
  if ($area eq 'main') {
    # first format all cells
    # no select background -selectbackground => 'lightblue',
    $w->formatGrid( @entbox, -selectbackground => 'gray70',
      -xon => 1, -xoff => 0, -yon => 1, -yoff => 0,
      -relief => 'raised', -bd => 0, -filled => 1, -bg => 'gray70');
    # format odd lines 1,3,5,7, ... (counting starts at 0!!!)
    $w->formatGrid( @entbox, -selectbackground => 'gray90',
      -xon => 1, -xoff => 0, -yon => 1, -yoff => 1,
      -relief => 'raised', -bd => 0, -filled => 1, -bg => 'gray90');
  }
  if ($area eq 'y_margin') {
    my ($ulx, $uly, $lrx, $lry) = @entbox;
    # format the checkbuttons backgrounds
    for my $i ($uly..$lry) {
      if ($w->infoExists(0,$i)) {
        my $cb = $w->entrycget(0, $i, "-window");
        $cb->configure(-background => (($i-$uly)%2 ? 'gray70' : 'gray90'));
      }
    }
    # first format all cells
    # no select background -selectbackground => 'lightblue',
    $w->formatBorder( @entbox, -selectbackground => 'gray70',
      -xon => 1, -xoff => 0, -yon => 1, -yoff => 0,
      -relief => 'raised', -bd => 0, -filled => 1, -bg => 'gray70');
    # format odd lines 1,3,5,7, ... (counting starts at 0!!!)
    $w->formatBorder( @entbox, -selectbackground => 'gray90',
      -xon => 1, -xoff => 0, -yon => 1, -yoff => 1,
      -relief => 'raised', -bd => 0, -filled => 1, -bg => 'gray90');
  }
}

####### actions frame

my $bot_frame = $back_f1->Labelframe(-text => "Actions");
$bot_frame->pack(@x_x, @p_ii);

my $actions_frame = $bot_frame->Frame;
$actions_frame->pack();

my $with_sel_frame = $actions_frame->Labelframe(-text => "with selected");
$with_sel_frame->pack(@left, @p_ii);
my $action_apply_filter = 1;
$with_sel_frame->Label(-text => "with filters")->pack(@left, @p_ii);

$with_sel_frame->Radiobutton(-text => "applied", 
        -variable => \$action_apply_filter, -value => 1)->pack(@left, @p_ii);
$with_sel_frame->Radiobutton(-text => "not applied", 
        -variable => \$action_apply_filter, -value => 0)->pack(@left, @p_ii);
$with_sel_frame->Button(-text => 'Install',
                        -state => $::action_button_state,
                        -command => sub { install_selected_packages(); }
  )->pack(@left, @p_ii);
$with_sel_frame->Button(-text => 'Upgrade',
                        -state => $::action_button_state,
                        -command => sub { update_selected_packages(); }
  )->pack(@left, @p_ii);
$with_sel_frame->Button(-text => 'Remove',
                        -state => $::action_button_state,
                        -command => sub { remove_selected_packages(); }
  )->pack(@left, @p_ii);
$with_sel_frame->Button(-text => 'Backup',
                        -state => $::action_button_state,
                        -command => sub { backup_selected_packages(); }
  )->pack(@left, @p_ii);

my $with_all_frame = $actions_frame->Labelframe(-text => "with all");
$with_all_frame->pack(@left, @p_ii);
$with_all_frame->Button(-text => 'Update all',
                        -state => $::action_button_state,
                        -command => sub { update_all_packages(); }
  )->pack(@a_c,@left,@p_ii);

######################## ARCH  ###########################

my @archsavail;
my @archsinstalled;
my %archs;
my $currentarch;

sub init_archs {
  if (!defined($tlmediatlpdb)) {
    @archsavail = $localtlpdb->available_architectures;
  } else {
    @archsavail = $tlmediatlpdb->available_architectures;
  }
  $currentarch = $localtlmedia->platform();
  @archsinstalled = $localtlpdb->available_architectures;
  foreach my $a (@archsavail) {
    $archs{$a} = 0;
    if (grep(/^$a$/,@archsinstalled)) {
      $archs{$a} = 1;
    }
  }
}


sub do_arch_settings {
  my $sw = $mw->Toplevel(-title => __("Select architectures to support"));
  my %archsbuttons;
  init_archs();
  $sw->transient($mw);
  $sw->grab();
  my $subframe = $sw->Labelframe(-text => __("Select architectures to support"));
  $subframe->pack(-fill => "both", -padx => "2m", -pady => "2m");
  foreach my $a (@archsavail) {
    $archsbuttons{$a} = 
      $subframe->Checkbutton(-command => sub { check_on_removal($sw, $a); },
                          -variable => \$archs{$a}, 
                          -text => platform_desc($a)
                         )->pack(-anchor => 'w');
  }
  my $arch_frame = $sw->Frame;
  $arch_frame->pack(-padx => "10m", -pady => "5m");
  $arch_frame->Button(-text => __("Apply changes"), 
    -state => $::action_button_state,
    -command => sub { apply_arch_changes(); $sw->destroy; })->pack(-side => 'left', -padx => "3m");
  $arch_frame->Button(-text => __("Cancel"), 
    -command => sub { $sw->destroy; })->pack(-side => 'left', -padx => "3m");
}

sub check_on_removal {
  my $arch_frame = shift;
  my $a = shift;
  if (!$archs{$a} && $a eq $currentarch) {
    # removal not supported
    $archs{$a} = 1;
    $arch_frame->Dialog(-title => "info",
                        -text => __("Removals of the main architecture not possible!"),
                        -buttons => [ __("Ok") ])->Show;
  }
}

sub apply_arch_changes {
  my @todo_add;
  my @todo_remove;
  foreach my $a (@archsavail) {
    if (!$archs{$a} && grep(/^$a$/,@archsinstalled)) {
      push @todo_remove, $a;
      next;
    }
    if ($archs{$a} && !grep(/^$a$/,@archsinstalled)) {
      push @todo_add, $a;
      next;
    }
  }
  if (@todo_add) {
    execute_action_gui ( "arch", "add", @todo_add );
  }
  if (@todo_remove) {
    execute_action_gui ( "arch", "remove", @todo_remove );
  }
  if (@todo_add || @todo_remove) {
    reinit_local_tlpdb();
    init_archs();
  }
}

########## CONFIG ###################
#
my @fileassocdesc;
$fileassocdesc[0] = __("None");
$fileassocdesc[1] = __("Only new");
$fileassocdesc[2] = __("All");
my %defaults;
my %changeddefaults;

sub init_defaults_setting {
  for my $key (keys %TeXLive::TLConfig::TLPDBOptions) {
    if ($TeXLive::TLConfig::TLPDBOptions{$key}->[0] eq "b") {
      $defaults{$key} = ($localtlpdb->option($key) ? 1 : 0);
    } else {
      $defaults{$key} = $localtlpdb->option($key);
    }
  }
}

sub do_general_settings {
  my $sw = $mw->Toplevel(-title => __("Default settings"));
  $sw->transient($mw);
  $sw->grab();
  init_defaults_setting();
  %changeddefaults = ();
  for my $k (keys %defaults) {
    $changeddefaults{$k}{'value'}   = $defaults{$k};
    if ($TeXLive::TLConfig::TLPDBOptions{$k}->[0] eq "b") {
      $changeddefaults{$k}{'display'} = ($defaults{$k} ? __("Yes") : __("No"));
    } else {
      if ($k eq "file_assocs") {
        $changeddefaults{$k}{'display'} = $fileassocdesc[$defaults{$k}];
      } else {
        $changeddefaults{$k}{'display'} = $defaults{$k};
      }
    }
  }

  my @config_set_l;
  my @config_set_m;
  my @config_set_r;

  my $back_config_set = $sw->Labelframe(-text => __("Default settings"));
  my $back_config_buttons = $sw->Frame();
  $back_config_set->pack(-fill => "both", -padx => "2m", -pady => "2m");

  push @config_set_l, 
    $back_config_set->Label(-text => __("Default package repository"), -anchor => "w");
  push @config_set_m,
    $back_config_set->Label(-textvariable => \$changeddefaults{"location"}{'display'});
  push @config_set_r,
    $back_config_set->Button(-text => __("Change"), 
      -command => sub { menu_default_location($sw); });


  push @config_set_l,
    $back_config_set->Label(-text => __("Create formats on installation"), -anchor => "w");
  push @config_set_m,
    $back_config_set->Label(-textvariable => \$changeddefaults{"create_formats"}{'display'});
  push @config_set_r,
    $back_config_set->Button(-text => __("Toggle"),
      -command => sub { toggle_setting("create_formats"); });

  push @config_set_l,
    $back_config_set->Label(-text => __("Install macro/font sources"), -anchor => "w");
  push @config_set_m,
    $back_config_set->Label(-textvariable => \$changeddefaults{"install_srcfiles"}{'display'});
  push @config_set_r,
    $back_config_set->Button(-text => __("Toggle"),
      -command => sub { toggle_setting("install_srcfiles"); });

  push @config_set_l,
    $back_config_set->Label(-text => __("Install macro/font docs"), -anchor => "w");
  push @config_set_m,
    $back_config_set->Label(-textvariable => \$changeddefaults{"install_docfiles"}{'display'});
  push @config_set_r,
    $back_config_set->Button(-text => __("Toggle"),
      -command => sub { toggle_setting("install_docfiles"); });

  push @config_set_l,
    $back_config_set->Label(-text => __("Default backup directory"), -anchor => "w");
  push @config_set_m,
    $back_config_set->Label(-textvariable => \$changeddefaults{"backupdir"}{'display'});
  push @config_set_r,
    $back_config_set->Button(-text => __("Change"),
      -command => sub { 
        my $dir = $sw->chooseDirectory();
        if (defined($dir) && ($defaults{"backupdir"} ne $dir)) {
          # see warning concerning UTF8 or other encoded dir names!!
          $changeddefaults{"backupdir"}{'value'} = $dir;
          $changeddefaults{"backupdir"}{'display'} = $dir;
        }
      });

  push @config_set_l,
    $back_config_set->Label(-text => __("Auto backup setting"), -anchor => "w");
  push @config_set_m,
    $back_config_set->Label(-textvariable => \$changeddefaults{"autobackup"}{'display'});
  push @config_set_r,
    $back_config_set->Button(-text => __("Change"),
      -command => sub { select_autobackup($sw); }, -anchor => "w");

  if (!win32()) {
    push @config_set_l,
      $back_config_set->Label(-text => __("Link destination for programs"), -anchor => "w");
    push @config_set_m,
      $back_config_set->Label(-textvariable => \$changeddefaults{"sys_bin"}{'display'});
    push @config_set_r,
      $back_config_set->Button(-text => __("Change"),
        -command => sub { 
          my $dir = $sw->chooseDirectory();
          if (defined($dir) && ($defaults{"sys_bin"} ne $dir)) {
            # see warning concerning UTF8 or other encoded dir names!!
            $changeddefaults{"sys_bin"}{'value'} = $dir;
            $changeddefaults{"sys_bin"}{'display'} = $dir;
          }
        });

    push @config_set_l,
      $back_config_set->Label(-text => __("Link destination for info docs"), -anchor => "w");
    push @config_set_m,
      $back_config_set->Label(-textvariable => \$changeddefaults{"sys_info"}{'display'});
    push @config_set_r,
      $back_config_set->Button(-text => __("Change"),
        -command => sub { 
          my $dir = $sw->chooseDirectory();
          if (defined($dir) && ($defaults{"sys_info"} ne $dir)) {
            # see warning concerning UTF8 or other encoded dir names!!
            $changeddefaults{"sys_info"}{'value'} = $dir;
            $changeddefaults{"sys_info"}{'display'} = $dir;
          }
        });

    push @config_set_l,
      $back_config_set->Label(-text => __("Link destination for man pages"), -anchor => "w");
    push @config_set_m,
      $back_config_set->Label(-textvariable => \$changeddefaults{"sys_man"}{'display'});
    push @config_set_r,
      $back_config_set->Button(-text => __("Change"),
        -command => sub { 
          my $dir = $sw->chooseDirectory();
          if (defined($dir) && ($defaults{"sys_man"} ne $dir)) {
            # see warning concerning UTF8 or other encoded dir names!!
            $changeddefaults{"sys_man"}{'value'} = $dir;
            $changeddefaults{"sys_man"}{'display'} = $dir;
          }
        });
  }

  if (win32()) {
    push @config_set_l,
      $back_config_set->Label(-text => __("Create shortcuts in menu and on desktop"), -anchor => "w");
    push @config_set_m,
      $back_config_set->Label(-textvariable => \$changeddefaults{"desktop_integration"}{'display'});
    push @config_set_r,
      $back_config_set->Button(-text => __("Toggle"),
        -command => sub { toggle_setting("desktop_integration"); });
  
    if (admin()) {
      push @config_set_l,
        $back_config_set->Label(-text => __("Install for all users"), -anchor => "w");
      push @config_set_m,
        $back_config_set->Label(-textvariable => \$changeddefaults{"w32_multi_user"}{'display'});
      push @config_set_r,
        $back_config_set->Button(-text => __("Toggle"),
          -command => sub { toggle_setting("w32_multi_user"); });
    }
  
    push @config_set_l,
      $back_config_set->Label(-text => __("Change file associations"), -anchor => "w");
    push @config_set_m,
      $back_config_set->Label(-textvariable => \$changeddefaults{'file_assocs'}{'display'});
    push @config_set_r,
      $back_config_set->Button(-text => __("Change"),
        -command => sub { select_file_assocs($sw); }, -anchor => "w");
  
  }
  
  for my $i (0..$#config_set_l) {
    $config_set_l[$i]->grid( $config_set_m[$i], $config_set_r[$i],
                              -padx => "1m", -pady => "1m", -sticky => "nwe");
  }

  $back_config_buttons->pack(-padx => "10m", -pady => "5m");
  $back_config_buttons->Button(-text => __("Apply changes"), 
    -state => $::action_button_state,
    -command => sub { apply_settings_changes(); $sw->destroy; })->pack(-side => 'left', -padx => "3m");
  $back_config_buttons->Button(-text => __("Cancel"), 
    -command => sub { $sw->destroy; })->pack(-side => 'left', -padx => "3m");
}
  
sub apply_settings_changes {
  for my $k (keys %defaults) {
    if ($defaults{$k} ne $changeddefaults{$k}{'value'}) {
      $localtlpdb->option($k, $changeddefaults{$k}{'value'});
    }
  }
  $localtlpdb->save;
}

######## PAPER #########
my %papers;
my %currentpaper;
my %changedpaper;

sub init_paper_xdvi {
  if (!win32()) {
    @{$papers{"xdvi"}} = TeXLive::TLPaper::get_paper_list("xdvi");
    $currentpaper{"xdvi"} = ${$papers{"xdvi"}}[0];
  }
}
sub init_paper_pdftex {
  @{$papers{"pdftex"}} = TeXLive::TLPaper::get_paper_list("pdftex");
  $currentpaper{"pdftex"} = ${$papers{"pdftex"}}[0];
}
sub init_paper_dvips {
  @{$papers{"dvips"}} = TeXLive::TLPaper::get_paper_list("dvips");
  $currentpaper{"dvips"} = ${$papers{"dvips"}}[0];
}
sub init_paper_dvipdfm {
  @{$papers{"dvipdfm"}} = TeXLive::TLPaper::get_paper_list("dvipdfm");
  $currentpaper{"dvipdfm"} = ${$papers{"dvipdfm"}}[0];
}
sub init_paper_context {
  if (defined($localtlpdb->get_package("bin-context"))) {
    @{$papers{"context"}} = TeXLive::TLPaper::get_paper_list("context");
    $currentpaper{"context"} = ${$papers{"context"}}[0];
  }
}
sub init_paper_dvipdfmx {
  @{$papers{"dvipdfmx"}} = TeXLive::TLPaper::get_paper_list("dvipdfmx");
  $currentpaper{"dvipdfmx"} = ${$papers{"dvipdfmx"}}[0];
}

my %init_paper_subs;
$init_paper_subs{"xdvi"} = \&init_paper_xdvi;
$init_paper_subs{"pdftex"} = \&init_paper_pdftex;
$init_paper_subs{"dvips"} = \&init_paper_dvips;
$init_paper_subs{"context"} = \&init_paper_context;
$init_paper_subs{"dvipdfm"} = \&init_paper_dvipdfm;
$init_paper_subs{"dvipdfmx"} = \&init_paper_dvipdfmx;

sub init_all_papers {
  for my $p (keys %init_paper_subs) {
    &{$init_paper_subs{$p}}();
  }
}


sub do_paper_settings {
  init_all_papers();
  my $sw = $mw->Toplevel(-title => __("Paper settings"));
  $sw->transient($mw);
  $sw->grab();
  
  %changedpaper = %currentpaper;

  my $lower = $sw->Frame;
  $lower->pack(-fill => "both");

  my $back_config_pap = $lower->Labelframe(-text => __("Paper settings"));
  my $back_config_buttons = $sw->Frame();


  my $back_config_pap_l1 = $back_config_pap->Label(-text => __("Default paper for all"), -anchor => "w");
  my $back_config_pap_m1 = $back_config_pap->Button(-text => "A4",
    -command => sub { change_paper("all", "a4"); });
  my $back_config_pap_r1 = $back_config_pap->Button(-text => "letter",
    -command => sub { change_paper("all", "letter"); });

  $back_config_pap_l1->grid( $back_config_pap_m1, $back_config_pap_r1,
    -padx => "2m", -pady => "2m", -sticky => "nswe");

  my (%l,%m,%r);
  foreach my $p (sort keys %papers) {
    if (($p eq "context") && !defined($localtlpdb->get_package("bin-context"))) {
      next;
    }
    $l{$p} = $back_config_pap->Label(-text => __("Default paper for") . " $p", -anchor => "w");
    $m{$p} = $back_config_pap->Label(-textvariable => \$changedpaper{$p}, -anchor => "w");
    $r{$p} = $back_config_pap->Button(-text => __("Change"),
      -command => sub { select_paper($sw,$p); }, -anchor => "w");
    $l{$p}->grid( $m{$p}, $r{$p},
      -padx => "2m", -pady => "2m", -sticky => "nsw");
}

  $back_config_pap->pack(-side => 'left', -fill => "both", -padx => "2m", -pady => "2m");

  $back_config_buttons->pack(-padx => "10m", -pady => "5m");
  $back_config_buttons->Button(-text => __("Apply changes"), 
    -state => $::action_button_state,
    -command => sub { apply_paper_changes(); $sw->destroy; })->pack(-side => 'left', -padx => "3m");
  $back_config_buttons->Button(-text => __("Cancel"), 
    -command => sub { $sw->destroy; })->pack(-side => 'left', -padx => "3m");
}


sub menu_default_location {
  my $mw = shift;
  my $val;
  my $sw = $mw->Toplevel(-title => __("Change default package repository"));
  $sw->transient($mw);
  $sw->grab();
  $sw->Label(-text => __("New default package repository"))->pack(-padx => "2m", -pady => "2m");

  my $f1 = $sw->Frame;
  my $entry = $f1->Entry(-text => $val, -width => 50);
  $entry->pack(-side => "left",-padx => "2m", -pady => "2m");

  my $f2 = $sw->Frame;
  $f2->Button(-text => __("Choose Directory"), 
    -command => sub {
                      my $var = $sw->chooseDirectory;
                      if (defined($var)) {
                        $entry->delete(0,"end");
                        $entry->insert(0,$var);
                      }
                    })->pack(-side => "left",-padx => "2m", -pady => "2m");
  $f2->Button(-text => __("Default net package repository"),
    -command => sub {
                      $entry->delete(0,"end");
                      $entry->insert(0,$TeXLiveURL);
                    })->pack(-side => "left",-padx => "2m", -pady => "2m");
  $f1->pack;
  $f2->pack;

  my $f = $sw->Frame;
  my $okbutton = $f->Button(-text => __("Ok"), 
    -command => sub { $changeddefaults{'location'}{'value'} = 
                        $changeddefaults{'location'}{'display'} = 
                          $entry->get;
                      $sw->destroy })->pack(-side => 'left',-padx => "2m", -pady => "2m");
  my $cancelbutton = $f->Button(-text => __("Cancel"), 
          -command => sub { $sw->destroy })->pack(-side => 'right',-padx => "2m", -pady => "2m");
  $f->pack(-expand => 'x');
  $sw->bind('<Return>', [ $okbutton, 'Invoke' ]);
  $sw->bind('<Escape>', [ $cancelbutton, 'Invoke' ]);
}

sub toggle_setting() {
  my ($key) = @_;
  my $old = $changeddefaults{$key}{'value'};
  my $new = ($old ? 0 : 1);
  $changeddefaults{$key}{'display'} = ($new ? __("Yes") : __("No"));
  $changeddefaults{$key}{'value'} = $new;
}


sub apply_paper_changes {
  $mw->Busy(-recurse => 1);
  for my $k (keys %changedpaper) {
    if ($currentpaper{$k} ne $changedpaper{$k}) {
      execute_action_gui ( "paper", $k, "paper", $changedpaper{$k});
      &{$init_paper_subs{$k}}();
    }
  }
  $mw->Unbusy;
}

sub change_paper {
  my ($prog, $pap) = @_;
  if ($prog eq "all") {
    for my $k (keys %changedpaper) {
      $changedpaper{$k} = $pap;
    }
  } else {
    $changedpaper{$prog} = $pap;
  }
}

sub select_paper {
  my $back_config = shift;
  my $prog = shift;
  my $foo = $back_config->Toplevel(-title => __("Select paper format for") . " $prog");
  $foo->transient($back_config);
  $foo->grab();
  my $var = $changedpaper{$prog};
  my $opt = $foo->BrowseEntry(-label => __("Default paper for") . " $prog", -variable => \$var);
  foreach my $p (sort @{$papers{$prog}}) {
    $opt->insert("end",$p);
  }
  $opt->pack(-padx => "2m", -pady => "2m");
  my $f = $foo->Frame;
  my $okbutton = $f->Button(-text => __("Ok"), -command => sub { change_paper($prog,$var); $foo->destroy; })->pack(-side => "left", -padx => "2m", -pady => "2m");
  my $cancelbutton = $f->Button(-text => __("Cancel"), -command => sub { $foo->destroy; })->pack(-side => "left", -padx => "2m", -pady => "2m");
  $f->pack;
  $foo->bind('<Return>', [ $okbutton, 'Invoke' ]);
  $foo->bind('<Escape>', [ $cancelbutton, 'Invoke' ]);
}

sub select_autobackup {
  my $mw = shift;
  my $foo = $mw->Toplevel(-title => __("Auto backup setting"));
  $foo->transient($mw);
  $foo->grab();
  my $var = $defaults{"autobackup"};
  my $opt = $foo->BrowseEntry(-label => __("Auto backup setting"), 
                              -variable => \$var);
  my @al;
  push @al, "-1 (" . __("keep arbitrarily many") . ")";
  push @al, "0  (" . __("disable") . ")";
  for my $i (1..100) {
    push @al, $i;
  }
  foreach my $p (@al) {
    $opt->insert("end",$p);
  }
  $opt->pack(-padx => "2m", -pady => "2m");
  my $f = $foo->Frame;
  my $okbutton = $f->Button(-text => __("Ok"), 
        -command => sub { 
                          $var =~ s/ .*$//;
                          $changeddefaults{"autobackup"}{'value'} = $var;
                          $changeddefaults{"autobackup"}{'display'} = $var;
                          $foo->destroy;
                        }
     )->pack(-side => "left", -padx => "2m", -pady => "2m");
  my $cancelbutton = $f->Button(-text => __("Cancel"), -command => sub { $foo->destroy; })->pack(-side => "left", -padx => "2m", -pady => "2m");
  $f->pack;
  $foo->bind('<Return>', [ $okbutton, 'Invoke' ]);
  $foo->bind('<Escape>', [ $cancelbutton, 'Invoke' ]);
}


sub select_file_assocs {
  my $sw = shift;
  my $foo = $sw->Toplevel(-title => __("Change file associations"));
  $foo->transient($mw);
  $foo->grab();
  my $var = $defaults{"file_assocs"};
  my $opt = $foo->BrowseEntry(-label => __("Change file associations"), 
                              -variable => \$var);
  my @al;
  for my $i (0..2) {
    push @al, "$i $fileassocdesc[$i]";
  }
  foreach my $p (@al) {
    $opt->insert("end",$p);
  }
  $opt->pack(-padx => "2m", -pady => "2m");
  my $f = $foo->Frame;
  my $okbutton = $f->Button(-text => __("Ok"), 
        -command => sub { 
                          $var = substr($var,0,1);
                          $changeddefaults{"file_assocs"}{'display'} = $fileassocdesc[$var];
                          $changeddefaults{"file_assocs"}{'value'} = $var;

                          $foo->destroy;
                        }
     )->pack(-side => "left", -padx => "2m", -pady => "2m");
  my $cancelbutton = $f->Button(-text => __("Cancel"), -command => sub { $foo->destroy; })->pack(-side => "left", -padx => "2m", -pady => "2m");
  $f->pack;
  $foo->bind('<Return>', [ $okbutton, 'Invoke' ]);
  $foo->bind('<Escape>', [ $cancelbutton, 'Invoke' ]);
}



################ END FUNCTIONS

if ($opts{"load"}) {
  run_update_functions();
}


info(__("Completed") . "\n");
$mw->deiconify;


if (!$::we_can_save) {
  my $no_write_warn = $mw->Dialog(-title => "warning",
    -text => __("You don't have permissions to change the installation in any way,\nspecifically, the directory %s is not writable.\nPlease run this program as administrator, or contact your local admin.\n\nMost buttons will be disabled.", "$Master/tlpkg/"),
    -buttons => [ __("Ok") ])->Show();
}

Tk::MainLoop();


sub init_install_media {
  my $newroot = $location;
  if (defined($tlmediatlpdb) && ($tlmediatlpdb->root eq $newroot)) {
    # nothing to be done
  } else {
    $mw->Busy(-recurse => 1);
    info(__("Loading remote TeX Live Database\nThis may take some time, please wait!") . "\n");
    $tlmediasrc = TeXLive::TLMedia->new($newroot);
    info(__("Completed") . "\n");
    $mw->Unbusy;
    if (!defined($tlmediasrc)) {
      # something went badly wrong, maybe the newroot is wrong?
      $mw->Dialog(-title => "warning",
                 -text => __("Could not load the TeX Live Database from %s\nIf you want to install or update packages, please try with a different package repository!\n\nFor configuration and removal you don\'t have to do anything.", $newroot),
                        -buttons => [ __("Ok") ])->Show;
      $tlmediatlpdb = undef;
      $tlmediasrc = undef;
      update_list_remote();
      update_grid();
      update_loaded_location_string("none");
    } else {
      $tlmediatlpdb = $tlmediasrc->tlpdb;
      update_list_remote();
      update_grid();
    }
  }
}

sub set_text_win {
  my ($w, $t) = @_;
  $w->delete("0.0", "end");
  $w->insert("0.0", "$t");
  $w->see("0.0");
}

sub install_selected_packages {
  my @foo = SelectedPackages();
  if (@foo) {
    my @args = qw/install/;
    push @args, @foo;
    execute_action_gui(@args);
    reinit_local_tlpdb();
    # now we check that the installation has succeeded by checking that 
    # all packages in @_ are installed. Otherwise we pop up a warning window
    my $do_warn = 0;
    for my $p (@_) {
      if (!defined($localtlpdb->get_package($p))) {
        $do_warn = 1;
        last;
      }
    }
    give_warning_window(__("Installation"), @_) if $do_warn;
  }
}

sub SelectedPackages {
  my @ret;
  # first select those that are
  for my $p (keys %Packages) {
    next if !$Packages{$p}{'selected'};
    if ($action_apply_filter) {
      if (MatchesFilters($p)) {
        push @ret, $p;
      }
    } else {
      push @ret, $p;
    }
  }
  return @ret;
}

sub update_all_packages {
  my @args = qw/update/;
  if ($critical_updates_present) {
    $opts{"self"} = 1;
  } else {
    $opts{"all"} = 1;
  }
  execute_action_gui(qw/update/);
  if ($critical_updates_present) {
    # terminate here immediately so that we are sure the auto-updater
    # is run immediately
    # make sure we exit in finish(0)
    $::gui_mode = 0;
    finish(0); 
  }
  reinit_local_tlpdb();
}
    
sub update_selected_packages {
  my @foo = SelectedPackages();
  if (@foo) {
    my @args = qw/update/;
    # argument processing
    # in case we have critical updates present we do put the list of
    # critical updates into the argument instead of --all
    if ($critical_updates_present) {
      $opts{"self"} = 1;
    }
    push @args, @foo;
    execute_action_gui(@args);
    if ($critical_updates_present) {
      # terminate here immediately so that we are sure the auto-updater
      # is run immediately
      # make sure we exit in finish(0)
      $::gui_mode = 0;
      finish(0); 
    }
    reinit_local_tlpdb();
  }
}

sub remove_selected_packages {
  my @foo = SelectedPackages();
  if (@foo) {
    my @args = qw/remove/;
    push @args, @foo;
    execute_action_gui(@args);
    reinit_local_tlpdb();
    my $do_warn = 0;
    for my $p (@_) {
      if (defined($localtlpdb->get_package($p))) {
        $do_warn = 1;
        last;
      }
    }
    give_warning_window(__("Remove"), @_) if $do_warn;
  }
}

sub backup_selected_packages {
  my @foo = SelectedPackages();
  if (@foo) {
    my @args = qw/backup/;
    push @args, @foo;
    execute_action_gui(@args);
  }
}

sub reinit_local_tlpdb {
  $mw->Busy(-recurse => 1);
  $localtlpdb = TeXLive::TLPDB->new ("root" => "$Master");
  die("cannot find tlpdb!") unless (defined($localtlpdb));
  setup_list();
  update_grid();
  $mw->Unbusy;
}

#
# creates/updates the list of packages as shown in tix grid
# 
sub setup_list {
  my @do_later;
  for my $p ($localtlpdb->list_packages()) {
    # collect packages containing a . for later
    # we want to ignore them in most cases but those where there is 
    # no father package (without .)
    if ($p =~ m;\.;) {
      push @do_later, $p;
      next;
    }
    my $tlp = $localtlpdb->get_package($p);
    # collect information about that package we will show
    $Packages{$p}{'displayname'}   = $p;
    $Packages{$p}{'localrevision'} = $tlp->revision;
    $Packages{$p}{'shortdesc'}     = $tlp->shortdesc;
    $Packages{$p}{'longdesc' }     = $tlp->longdesc;
    $Packages{$p}{'installed'}     = 1;
    $Packages{$p}{'selected'}      = 0;
    $Packages{$p}{'cb'}            = $g->Checkbutton(-variable => \$Packages{$p}{'selected'});
    if (($tlp->category eq "Collection") ||
        ($tlp->category eq "Scheme")) {
      $Packages{$p}{'category'}      = $tlp->category;
    } else {
      $Packages{$p}{'category'}      = "Other";
    }
    if (defined($tlp->cataloguedata->{'version'})) {
      $Packages{$p}{'localcatalogueversion'} = $tlp->cataloguedata->{'version'};
    }
  }
  for my $p (@do_later) {
    my $s = $p;
    $s =~ s!\.[^.]*$!!;
    if (!defined($Packages{$s})) {
      my $tlp = $localtlpdb->get_package($p);
      # collect information about that package we will show
      $Packages{$p}{'displayname'}   = $p;
      $Packages{$p}{'localrevision'} = $tlp->revision;
      $Packages{$p}{'shortdesc'}     = $tlp->shortdesc;
      $Packages{$p}{'longdesc' }     = $tlp->longdesc;
      $Packages{$p}{'installed'}     = 1;
      $Packages{$p}{'selected'}      = 0;
      $Packages{$p}{'cb'}            = $g->Checkbutton(-variable => \$Packages{$p}{'selected'});
      if (($tlp->category eq "Collection") ||
          ($tlp->category eq "Scheme")) {
        $Packages{$p}{'category'}      = $tlp->category;
      } else {
        $Packages{$p}{'category'}      = "Other";
      }
      if (defined($tlp->cataloguedata->{'version'})) {
        $Packages{$p}{'localcatalogueversion'} = $tlp->cataloguedata->{'version'};
      }
    }
  }
  update_list_remote();
}

sub update_list_remote {
  my @do_later_media;
  print "TODO move the check from critical_updates_present from the old sub create_update_list here!!!";
  # clear old info from remote media
  for my $p (keys %Packages) {
    if (!$Packages{$p}{'installed'}) {
      delete $Packages{$p};
      next;
    }
    delete $Packages{$p}{'remoterevision'};
    delete $Packages{$p}{'remotecatalogueversion'};
  }
  if (defined($tlmediatlpdb)) {
    for my $p ($tlmediatlpdb->list_packages()) {
      if ($p =~ m;\.;) {
        push @do_later_media, $p;
        next;
      }
      my $tlp = $tlmediatlpdb->get_package($p);
      $Packages{$p}{'displayname'}   = $p;
      $Packages{$p}{'remoterevision'} = $tlp->revision;
      # overwrite, we assume that the remove version is better ;-)
      $Packages{$p}{'shortdesc'}     = $tlp->shortdesc;
      $Packages{$p}{'longdesc' }     = $tlp->longdesc;
      $Packages{$p}{'selected'}      = 0
        unless defined $Packages{$p}{'selected'};
      $Packages{$p}{'cb'}            = $g->Checkbutton(-variable => \$Packages{$p}{'selected'})
        unless defined $Packages{$p}{'cb'};
      if (($tlp->category eq "Collection") ||
          ($tlp->category eq "Scheme")) {
        $Packages{$p}{'category'}      = $tlp->category;
      } else {
        $Packages{$p}{'category'}      = "Other";
      }
      if (defined($tlp->cataloguedata->{'version'})) {
        $Packages{$p}{'remotecatalogueversion'} = $tlp->cataloguedata->{'version'};
      }
    }
  }
  for my $p (@do_later_media) {
    my $s = $p;
    $s =~ s!\.[^.]*$!!;
    if (!defined($Packages{$s})) {
      my $tlp = $tlmediatlpdb->get_package($p);
      # collect information about that package we will show
      $Packages{$p}{'displayname'}   = $p;
      $Packages{$p}{'remoterevision'} = $tlp->revision;
      $Packages{$p}{'shortdesc'}     = $tlp->shortdesc;
      $Packages{$p}{'longdesc' }     = $tlp->longdesc;
      $Packages{$p}{'selected'}      = 0
        unless defined $Packages{$p}{'selected'};
      $Packages{$p}{'cb'}            = $g->Checkbutton(-variable => \$Packages{$p}{'selected'})
        unless defined $Packages{$p}{'cb'};
      if (($tlp->category eq "Collection") ||
          ($tlp->category eq "Scheme")) {
        $Packages{$p}{'category'}      = $tlp->category;
      } else {
        $Packages{$p}{'category'}      = "Other";
      }
      if (defined($tlp->cataloguedata->{'version'})) {
        $Packages{$p}{'remotecatalogueversion'} = $tlp->cataloguedata->{'version'};
      }
    }
  }
  # change display names
  for my $p (keys %Packages) {
    if ($p =~ m/^collection-documentation-(.*)$/) {
      $Packages{$p}{'displayname'} = "collection-doc-$1";
    }
  }
}


sub menu_edit_location {
  my $key = shift;
  my $val;
  my $sw = $mw->Toplevel(-title => __("Load package repository"));
  $sw->transient($mw);
  $sw->grab();
  $sw->Label(-text => __("Package repository:"))->pack(@p_ii);
  my $entry = $sw->Entry(-text => $location, -width => 30);
  $entry->pack();
  my $f1 = $sw->Frame;
  $f1->Button(-text => __("Choose Directory"),
    -command => sub {
                      my $var = $sw->chooseDirectory;
                      if (defined($var)) {
                        $entry->delete(0,"end");
                        $entry->insert(0,$var);
                      }
                    })->pack(@left, @p_ii);
  $f1->Button(-text => __("Default net package repository"),
    -command => sub {
                      $entry->delete(0,"end");
                      $entry->insert(0,$TeXLiveURL);
                    })->pack(@left, @p_ii);
  $f1->pack;
  my $f = $sw->Frame;
  my $okbutton = $f->Button(-text => __("Ok"),
    -command => sub { $location = $entry->get;
                      $sw->destroy;
                      update_loaded_location_string();
                      run_update_functions();
                    })->pack(@left, @p_ii);
  my $cancelbutton = $f->Button(-text => __("Cancel"),
          -command => sub { $sw->destroy })->pack(@right, @p_ii);
  $f->pack(-expand => 1);
  $sw->bind('<Return>', [ $okbutton, 'Invoke' ]);
  $sw->bind('<Escape>', [ $cancelbutton, 'Invoke' ]);
}

sub update_loaded_location_string {
  my $arg = shift;
  $arg || ($arg = $location);
  $menu->entryconfigure('end', -label => "Loaded repository: $arg");
}

sub run_update_functions {
  foreach my $f (@update_function_list) {
    &{$f}();
  }
}

sub check_location_on_ctan {
  # we want to check that if mirror.ctan.org
  # is used that we select a mirror once
  if ($location =~ m/$TeXLive::TLConfig::TeXLiveServerURL/) {
    $location = TeXLive::TLUtils::give_ctan_mirror();
  }
}

sub execute_action_gui {
  $mw->Busy(-recurse => 1);
  info ("Executing action @_\n");
  execute_action(@_);
  info(__("Completed") . "\n");
  $mw->Unbusy;
}

sub give_warning_window {
  my ($act, @args) = @_;
  my $sw = $mw->DialogBox(-title => __("Warning Window"), -buttons => [ __("Ok") ]);
  $sw->add("Label", -text => __("Running %s failed.\nPlease consult the log window for details.", "$act @args")
    )->pack(@p_iii);
  $sw->Show;
}

1;

__END__


### Local Variables:
### perl-indent-level: 2
### tab-width: 2
### indent-tabs-mode: nil
### End:
# vim:set tabstop=2 expandtab: #
