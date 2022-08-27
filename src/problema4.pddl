(define (problem e4)
    (:domain e4-dom)
    (:objects
        localizacion11 localizacion12 localizacion13 localizacion14
        localizacion21 localizacion22 localizacion23 localizacion24
        localizacion31 localizacion32 localizacion33 localizacion34
        localizacion44 - localizacion
        CentroDeMando1 Extractor1 Barracones1 - edificios
        VCE1 VCE2 VCE3 Marine1 Marine2 Soldado1 - unidades
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
        (edifEn CentroDeMando1 localizacion11)
        (construido localizacion11)
        (edifConstruido CentroDeMando1)
        (tipoEdif Extractor1 Extractor)
        (tipoEdif Barracones1 Barracones)
        (tipoUnid VCE1 VCE)
        (tipoUnid VCE2 VCE)
        (tipoUnid VCE3 VCE)
        (tipoUnid Marine1 Marine)
        (tipoUnid Marine2 Marine)
        (tipoUnid Soldado1 Soldado)
        (tipoRecur r1 Minerales)
        (tipoRecur r2 Gas)
        (unidEn VCE1 localizacion11)
        (nodo r1 localizacion22)
        (nodo r1 localizacion32)
        (nodo r2 localizacion44)
        (necesita Extractor r1)
        (necesita Barracones r1)
        (necesita Barracones r2)
        (requiere Soldado r1)
        (requiere Soldado r2)
        (requiere VCE r1)
        (requiere Marine r1)
        (edifReclu Marine Barracones)
        (edifReclu Soldado Barracones)
        (edifReclu VCE CentroDeMando)
    )
    (:goal
        (and
            (edifEn Barracones1 localizacion32)
            (unidEn Marine1 localizacion31)
            (unidEn Marine2 localizacion24)
            (unidEn Soldado1 localizacion12)
        )
    )
)
