echo "======>>>> Start pre build configure"

srcroot=$1
configuration=$2

cd ..
srcroot=$PWD

sourcesPath=$srcroot/RakutenAdvertisingAttribution/Source/
outputPath=$srcroot/RakutenAdvertisingAttribution/Source/Models/SourceryGenerated
templatesPath=$srcroot/SourceryTemplates
$srcroot/Example/Pods/Sourcery/bin/sourcery --sources $sourcesPath --templates $templatesPath --output $outputPath

echo "======<<<< End pre build configure"
