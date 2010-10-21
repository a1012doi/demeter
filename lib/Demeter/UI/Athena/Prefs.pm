package Demeter::UI::Athena::Prefs;

use Demeter::UI::Wx::Config;

use Wx qw( :everything );
use base 'Wx::Panel';
use Wx::Event qw(EVT_BUTTON);

use vars qw($label $tag);
$label = "Preferences";
$tag = 'Prefs';

sub new {
  my ($class, $parent, $app) = @_;
  my $this = $class->SUPER::new($parent, -1, wxDefaultPosition, wxDefaultSize, wxMAXIMIZE_BOX );

  my $box = Wx::BoxSizer->new( wxVERTICAL);
  $this->{sizer}  = $box;
  $this->{parent} = $parent;

  my $config = Demeter::UI::Wx::Config->new($this, \&target);
  $config->populate([qw(athena bft bkg clamp convolution fft file fit gnuplot indicator
			interpolation marker merge operations plot rebin xanes)]);
  $box->Add($config, 1, wxGROW|wxALL, 5);

  $this->{document} = Wx::Button->new($this, -1, 'Document section: preferences');
  $this->{return}   = Wx::Button->new($this, -1, 'Return to main window');
  $box -> Add($this->{$_}, 0, wxGROW|wxALL, 2) foreach (qw(document return));
  EVT_BUTTON($this, $this->{document}, sub{  $app->document("preferences")});
  EVT_BUTTON($this, $this->{return},   sub{  $app->{main}->{views}->SetSelection(0); $app->OnGroupSelect});

  $this->SetSizerAndFit($box);
  return $this;
};

sub target {
  my ($self, $parent, $param, $value, $save) = @_;

 SWITCH: {
    ($param eq 'plotwith') and do {
      $Demeter::UI::Athena::demeter->plot_with($value);
      last SWITCH;
    };
  };

  ($save)
    ? $::app->{main}->status("Now using $value for $parent-->$param and an ini file was saved")
      : $::app->{main}->status("Now using $value for $parent-->$param");

};

sub pull_values {
  my ($this, $data) = @_;
  1;
};
sub push_values {
  my ($this, $data) = @_;
  1;
};
sub mode {
  my ($this, $data, $enabled, $frozen) = @_;
  1;
};

1;