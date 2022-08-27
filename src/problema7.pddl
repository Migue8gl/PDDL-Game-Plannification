(define (problem e7)
    (:domain e7-dom)
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
        (existe VCE1) 

        (nodo r1 localizacion22)
        (nodo r1 localizacion32) 
        (nodo r2 localizacion44)

        (= (deposVCE Minerales ) 0)
        (= (deposVCE Gas ) 0)

        (= (necesita Extractor Minerales) 10)
        (= (necesita Extractor Gas) 0)
        (= (necesita Barracones Minerales) 30)
        (= (necesita Barracones Gas) 10)

        (= (requiere Soldado Minerales) 30)
        (= (requiere Soldado Gas) 30)
        (= (requiere VCE Minerales) 5)
        (= (requiere VCE Gas) 0)
        (= (requiere Marine Minerales) 10)
        (= (requiere Marine Gas) 15)

        (edifReclu Marine Barracones)
        (edifReclu Soldado Barracones)
        (edifReclu VCE CentroDeMando)
		(= (almacen Gas) 0)
		(= (almacen Minerales) 0)

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