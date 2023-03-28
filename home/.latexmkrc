$pdflatex = 'pdflatex -synctex=1 -interaction=nonstopmode --shell-escape %O %S';

$bibtex_use = 2;
push @generated_exts, "cb";
push @generated_exts, "aux";
push @generated_exts, "cb2";
push @generated_exts, "spl";
push @generated_exts, "nav";
push @generated_exts, "snm";
push @generated_exts, "tdo";
push @generated_exts, "nmo";
push @generated_exts, "brf";
push @generated_exts, "nlg";
push @generated_exts, "nlo";
push @generated_exts, "nls";
push @generated_exts, "acn";
push @generated_exts, "alg";
push @generated_exts, "glg";
push @generated_exts, "gls";
push @generated_exts, "acr";
push @generated_exts, "def";
push @generated_exts, "glo";
push @generated_exts, "ist";
push @generated_exts, "synctex.gz";
push @generated_exts, "run.xml";
push @generated_exts, "xdv";

##############
# Glossaries #
##############
add_cus_dep( 'glo', 'gls', 0, 'glo2gls' );
add_cus_dep( 'acn', 'acr', 0, 'glo2gls');  # from Overleaf v1
sub glo2gls {
    system("makeglossaries $_[0]");
}

#############
# makeindex #
#############
@ist = glob("*.ist");
if (scalar(@ist) > 0) {
    $makeindex = "makeindex -s $ist[0] %O -o %D %S";
}
