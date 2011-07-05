#!/usr/bin/perl -w

# use module
use XML::Simple;
use Data::Dumper;
my $style="";
my $gw="";
`cat /tmp/shd.txt|sort > /tmp/shdordered.txt`;
open FILE2, "> /tmp/shdordered.kml" or die $!;
open FILE, "/tmp/shdordered.txt" or die $!;
print <<START;
<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2">
<Document>
 <Style id="steStyles">
 <IconStyle id="icon">
        <Icon>
          <href>http://google.com/mapfiles/ms/micons/blue.png</href>
        </Icon>
 </IconStyle>
 </Style>
 <Style id="eriStyles">
 <IconStyle id="icon">
        <Icon>
          <href>http://google.com/mapfiles/ms/micons/purple.png</href>
        </Icon>
 </IconStyle>
 </Style>
 <Style id="wstStyles">
 <IconStyle id="icon">
        <Icon>
          <href>http://google.com/mapfiles/ms/micons/red.png</href>
        </Icon>
 </IconStyle>
 </Style>
 <open>1</open>
START
while (<FILE>) {
  my ($user,$kunde,$strasse,$nummer,$stadt,$land,$beschreibung) = split(";",$_);
  $style=$user."Styles";
  # create object
  $xml = new XML::Simple;
  my $gecode = `elinks -source "http://maps.google.com/maps/api/geocode/xml?address=$strasse+$nummer,+$stadt,+$land&sensor=true"`;
  # read XML file
  $data = $xml->XMLin($gecode);
  # access XML data
  if ($gw ne $user){
  print <<FOLDER;
  <Folder> 
    <open>1</open>
    <name>$user Kunden</name>
    <description>die von $user vorgesehenen Kundenbesuche</description>
FOLDER
  };
print <<DATEN;
  <Placemark>
    <name>$kunde</name>
    <description>$beschreibung</description>
    <styleUrl>#$style</styleUrl>
    <Point>
      <coordinates>$data->{result}->{geometry}->{location}->{lng},$data->{result}->{geometry}->{location}->{lat},0</coordinates>
    </Point>
  </Placemark>
DATEN
$gw = $user;
};

print <<END;
</Document>
</kml>
END
close (FILE);
close (FILE2);
#print Dumper($data);