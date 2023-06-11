{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.science.bioinfo;
in {
  options.modules.science.bioinfo = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable (mkMerge [
    {
      user.packages = with pkgs; [
        unstable.igv
	unstable.bwa
	unstable.blast
	unstable.bowtie2
	unstable.deeptools
	unstable.fastp
	unstable.hmmer
	unstable.megahit
	unstable.minimap2
	unstable.mmseqs2
	unstable.sambamba
	unstable.samtools
	unstable.seqtk
	unstable.seqkit
	unstable.SPAdes
	unstable.sratoolkit
	unstable.star
        unstable.vcftools
        unstable.bedtools
        unstable.bcftools
        unstable.bftools
	#unstable.kent
        unstable.gatk
	unstable.hisat2
        unstable.mafft
        unstable.muscle
        unstable.minia
      ];
    }
  ]);
}
