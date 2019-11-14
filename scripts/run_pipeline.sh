mkdir -p res/genome
echo "DESCARGA DEL GENOMA DE ECOLI..."
wget -O res/genome/ecoli.fasta.gz ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/005/845/GCF_000005845.2_ASM584v2/GCF_000005845.2_ASM584v2_genomic.fna.gz
echo "DESCOMPRESION DEL FICHERO DEL GENOMA..."
gunzip -k res/genome/ecoli.fasta.gz

echo "INDEXACION DEL GENOMA. Running STAR index..."
mkdir -p res/genome/star_index
STAR --runThreadN 4 --runMode genomeGenerate --genomeDir res/genome/star_index/ --genomeFastaFiles res/genome/ecoli.fasta --genomeSAindexNbases 9
echo

echo "GENERACION Y ANALISIS DE MUESTRAS..."
for sampleid in $(ls data/*.fastq.gz | cut -d"_" -f1 | sed 's:data/::' | sort | uniq)
do
bash scripts/analyse_sample.sh $sampleid
echo "LA MUESTRA $sampleid SE ANALIZO"
echo
done

echo "REPORTE DEL PROCESO..."
multiqc -o out/multiqc .
mkdir -p envs
conda env export > envs/rna-seq.yaml

