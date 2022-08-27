(define (problem e2)
    (:domain e2-dom)
    (:objects
        localizacion11 localizacion12 localizacion13 localizacion14
        localizacion21 localizacion22 localizacion23 localizacion24
        localizacion31 localizacion32 localizacion33 localizacion34
        localizacion44 - localizacion
        CentroDeMando1 Extractor1 - edificios
        VCE1 VCE2 - unidades
        r1 r2 - recursos
    )
    (:init
        (conectado localizacion11 localizacion12)
        (conectado localizacion12 localizacion11)
        (conectado localizacion11 localizacion21)
        (conectado localizacion21 localizacion11)
        (conectado localizacion12 localizacion22)
        (conectado localizacion22 localizacion12)
        (conectado localizacion31 localizacion32)
        (conectado localizacion32 localizacion31)
        (conectado localizacion21 localizacion31)
        (conectado localizacion31 localizacion21)
        (conectado localizacion22 localizacion32)
        (conectado localizacion32 localizacion22)

        (conectado localizacion22 localizacion23)
        (conectado localizacion23 localizacion22)
        (conectado localizacion13 localizacion14)
        (conectado localizacion14 localizacion13)
        (conectado localizacion13 localizacion23)
        (conectado localizacion23 localizacion13)
        (conectado localizacion14 localizacion24)
        (conectado localizacion24 localizacion14)
        (conectado localizacion33 localizacion23)
        (conectado localizacion23 localizacion33)
        (conectado localizacion24 localizacion34)
        (conectado localizacion34 localizacion24)
        (conectado localizacion33 localizacion34)
        (conectado localizacion34 localizacion33)
        (conectado localizacion34 localizacion44)
        (conectado localizacion44 localizacion34)

        (tipoEdif CentroDeMando1 CentroDeMando)
        (tipoEdif Extractor1 Extractor)
        (tipoUnid VCE1 VCE)
        (tipoUnid VCE2 VCE)
        (tipoRecur r1 Minerales)
        (tipoRecur r2 Gas)
        (edifEn CentroDeMando1 localizacion11)
        (unidEn VCE1 localizacion11)
        (unidEn VCE2 localizacion11)
        (nodo r1 localizacion22)
        (nodo r1 localizacion32)
        (nodo r2 localizacion44)
    )
    (:goal
        (and
            (extrayendo VCE1 r1)
            (extrayendo VCE2 r2)
        )
    )
)
