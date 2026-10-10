function [Me]=elm(le,m,J0);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Assemble element mass matrix
% File name: elM.m
% 
% le [m]	Element length
% m  [kg]	Element mass per unit length
% Me is returned - element mass matrix
%
% Make sure the mass matrix is symmetric!
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Me=(le*m/420).*[156,   -22*le,   54,    13*le;
               -22*le, 4*(le.^2),-13*le,-3*(le.^2);
                54,   -13*le,    156, 2  2*le;
                13*le,-3*(le.^2),22*le, 4*(le.^2)];