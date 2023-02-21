#accepts two arguments:
#first argument is input directory
#second argument is output directory
#it creates the output directory

#creates a conda environment called bam2bigwig with all required packages
mamba create -n bam2bigwig samtools deeptools --yes
source $(dirname $(dirname $(which mamba)))/etc/profile.d/conda.sh
conda activate bam2bigwig

#variables
input_dir=$1
output_dir=$2
echo $input_dir
echo $output_dir
mkdir $output_dir
cp $input_dir/*.bam $output_dir

#create an empty file for log files
log=bam2bigwig.log
echo $log

#convert bam files to bigwig files
input_files=$(ls ${output_dir})
echo $input_files
cd $output_dir
for file in ${input_files[@]}; do
	#get the path to each input file and output directory
	input=$file
	file_without_suffix=${file::-4}
	outdir=$output_dir/$(basename $file).bw

	#print what file is used
	echo ""
	echo input: $input
	echo outdir: $outdir

	#run samtools
	nice -n 5 samtools index -b $input > $log 2>&1

	#run bamCoverage
	nice -n 5 bamCoverage -b $input -o $outdir > $log 2>&1

done

rm *.bam
rm *.bai

echo "Ellen van de Logt"


