classdef robot_model
    properties 
        ndof

        l
        lc
        d
        dc

        yc

        m
        I

        DH

        struct
    end
    methods
        function obj = robot_model(ndof,l,lc,d,dc,DH,m,I)
            obj.ndof = ndof;
            obj.l = l;
            obj.lc = lc;
            obj.d = d;
            obj.dc = dc;


            obj.m = m;
            obj.I = I;
            obj.DH = DH;


            obj.struct.ndof = ndof;
            obj.struct.l = l;
            obj.struct.lc = lc;
            obj.struct.d = d;
            obj.struct.dc = dc;
            obj.struct.DH = DH;

            obj.struct.m = m;
            obj.struct.I = I;
        end
    end
end