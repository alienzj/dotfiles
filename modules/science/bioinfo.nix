{
  hey,
  lib,
  options,
  config,
  pkgs,
  ...
}:
with lib;
with hey.lib; let
  cfg = config.modules.science.bioinfo;
in {
  options.modules.science.bioinfo = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable (mkMerge [
    {
      user.packages = with pkgs.unstable; [
        igv
        bwa
        blast
        bowtie2
        deeptools
        diamond
        jbrowse
        fastp
        hmmer
        megahit
        minimap2
        mmseqs2
        sambamba
        samtools
        seqtk
        seqkit
        SPAdes
        sratoolkit
        star
        vcftools
        bedtools
        bcftools
        bftools
        #kent
        gatk
        hisat2
        mafft
        muscle
        minia
        clustal-omega
        seaview
        freebayes
        mrbayes
        raxml-mpi
        veryfasttree
        iqtree
        # TODO
        # unstable.ugene
      ];
    }
  ]);
}
