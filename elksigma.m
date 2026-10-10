function [Kesigma]=elksigma(le,P,I0,A)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Assemble element initial stress stiffness matrix
    % File name: elksigma.m
    % 
    % le [m]	Element length
    % P  [N]	"Tensile" buckling load
    % Kesigma is returned - element initial stress matrix
    %
    % Make sure the initial stress matrix is symmetric!
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % matrix due to bending loads
    Kesigma1 = P / (30 * le) * [
           36,  -3*le,   0,   -36,  -3*le,  0; 

        -3*le, 4*le^2,   0,  3*le,  -le^2,  0;

            0,      0,   0,     0,      0,  0;
    
          -36,   3*le,   0,    36,   3*le,  0;

        -3*le,  -le^2,   0,  3*le, 4*le^2,  0;

            0,      0,   0,     0,      0,  0;

    ];

    % matrix due to torsion loads
    Kesigma2 = P * I0 / (A * le) * [ 
        0, 0, 0, 0, 0, 0;
        0, 0, 0, 0, 0, 0;
        0, 0, 1, 0, 0,-1;
        0, 0, 0, 0, 0, 0;
        0, 0, 0, 0, 0, 0;
        0, 0,-1, 0, 0, 1;
    ];

    Kesigma = Kesigma1 + Kesigma2;

end
