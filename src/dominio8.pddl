(define (domain e8-dom)
    (:requirements :strips :typing :adl :fluents :quantified-preconditions :conditional-effects)
    (:types
        unidades edificios localizacion recursos tipoUnid tipoEdif tipoRecur - object
    )
    (:constants
        VCE Marine Soldado - tipoUni
        CentroDeMando Barracones Extractor - tipoEdif
        Minerales Gas - tipoRecur
    )
    (:functions
        (almacen ?r - tipoRecur)
        (deposVCE ?r - tipoRecur)
        (necesita ?te - tipoEdif ?tr - tipoRecur);;el edificio e necesita recurso r
        (requiere ?u - tipoUni ?r - tipoRecur);;indica que recursos necesita una unidad para ser creada
        (tiempoUnid ?tu - tipoUni) ;;tiempo que tarda una unidad
        (tiempoEdif ?te - tipoEdif);;tiempo que tarda un edificio en ser construido
        (tiempoRecolectar) ;;;tiempo que se tarda en recolectar
        (distanciaLocalizacion);;;distancia entre dos localizaciones
        (velocidadUnid ?tu - tipoUni);;velocidad de cada unidad
        (tiempoTranscurrido);; tiempo a minimizar
    )
    (:predicates
        (conectado ?x ?y - localizacion) ;;si dos localizaciones son navegables de izq a der
        (edifEn ?e - edificios ?x - localizacion) ;;si el edificio e está construido en x
        (unidEn ?u - unidades ?x - localizacion);;si la unidad u está en x
        (construido ?x - localizacion);;si hay algún edificio en x
        (nodo ?r - recursos ?x - localizacion);;se asigna nodo de recurso r a x
        (extrayendo ?u - unidades ?r - recursos);;unidad u extrayendo recurso r
        (tipoUnid ?u - unidades ?tu - tipoUni);;tipo de unidad
        (tipoEdif ?e - edificios  ?te - tipoEdif);;tipo de edificio
        (tipoRecur ?r - recursos ?tr - tipoRecur);;tipo de recurso
        (ocupado ?u - unidades);;la unidad un está ocupada
        (existe ?u - unidades);;si existe esa unidad
        (edifReclu ?tu - tipoUni ?te - tipoEdif);;la unidad se recluta en el edificio e
        (edifConstruido ?e - edificios);;indica que ese edificio ya está construido
    )

    (:action navegar ;;si se puede ir de x a y lo hace
        :parameters (?u - unidades ?x ?y - localizacion)
        ;;miro que esté conectada x con y, que la unidad esté en x y que no esté ocupada
        :precondition
            (and
                (conectado ?x ?y)
                (unidEn ?u ?x)
                (not(ocupado ?u))
            )
        ;;la unidad no está ya en x, está en y
        ;; incrementamos el tiempo transcurrido en la distancia recorrida por lo que tarda una unidad en recorrerla
        :effect
            (and
                (unidEn ?u ?y)
                (not(unidEn ?u ?x))
                (when(tipoUnid ?u VCE)
                    (increase (tiempoTranscurrido) (/(distanciaLocalizacion) (velocidadUnid VCE)))
                )
                (when(tipoUnid ?u Soldado)
                    (increase (tiempoTranscurrido) (/(distanciaLocalizacion) (velocidadUnid Soldado)))
                )
                (when(tipoUnid ?u Marine)
                    (increase (tiempoTranscurrido) (/(distanciaLocalizacion) (velocidadUnid Marine)))
                )
            )
    )

    (:action asignar ;;asigna una unidad a una localización para extraer recursos
        :parameters (?u - unidades ?x - localizacion ?r - recursos)
        ;;compruebo si esa localización es explotable(tiene recursos),
        ;;miro el tipo de unidad(VCE),
        ;;miro que no esté ocupada y si necesita un material para construir
        ;;un edificio que permita extraer
        :precondition
            (and
                (nodo ?r ?x)
                (unidEn ?u ?x)
                (tipoUnid ?u VCE)
                (not(ocupado ?u))
                (or (tipoRecur ?r Minerales)
                    (and
                        (tipoRecur ?r Gas)
                        (exists (?e - edificios)
                            (and
                                (tipoEdif ?e Extractor)
                                (edifEn ?e ?x)
                            )
                        )
                    )
                )
            )
        ;;la unidad comienza a extraer y está ocupada
        :effect
            (and
                (extrayendo ?u ?r)
                (ocupado ?u)
                (forall(?tr - tipoRecur)
                    (when(tipoRecur ?r ?tr)
                        (increase (deposVCE ?tr) 10)
                    )
                )
            )
    )

    (:action construir ;;construye un edificio
        :parameters (?u - unidades ?e - edificios ?x - localizacion)
        ;;si la unidad es VCE, no está ocupada y está en el sitio, además
        ;;compruebo que en la localización no haya ningún edificio ni el propio que
        ;;queremos construir. Luego compruebo que tenemos los materiales necesarios
        ;;para construir
        :precondition
            (and
                (tipoUnid ?u VCE)
                (unidEn ?u ?x)
                (not(ocupado ?u))
                (not(edifEn ?e ?x))
                (not(construido ?x))
                (not(edifConstruido ?e))

                (forall (?tr - tipoRecur)
                    (exists (?te - tipoEdif)
                        (and
                            (tipoEdif ?e ?te)
                                (>= (almacen ?tr) (necesita ?te ?tr) )
                        )
                    )
                )
            )
        ;;el edificio es construido en x y x está ocupada
        ;; incrementamos el tiempo transcurrido en lo que tarde el edificio en construirse
        :effect
            (and
                (edifEn ?e ?x)
                (construido ?x)
                (edifConstruido ?e)
                (forall (?te - tipoEdif ?tr - tipoRecur)
                    (when (tipoEdif ?e ?te)
                        (decrease (almacen ?tr) (necesita ?te ?tr))
                    )
                )
                (when (tipoEdif ?e Barracones)
                    (increase (tiempoTranscurrido) (tiempoEdif Barracones))
                )
                (when (tipoEdif ?e Extractor)
                    (increase (tiempoTranscurrido) (tiempoEdif Extractor))
                )
            )
    )

    (:action reclutar ;;recluta unidades
        :parameters (?e - edificios ?u - unidades ?x - localizacion)
        ;;si el edificio está en x y no existe la unidad todavía, además
        ;;compruebo si el tipo de unidad coincide con el tipo de edifio de reclutamiento,
        ;;pues cada unidad se recluta en un sitio distinto. También miro el recurso o recursos
        ;;que necesite la unidad
        :precondition
            (and
                (edifEn ?e ?x)
                (not(existe ?u))
                (exists (?tu - tipoUni ?te - tipoEdif)
                    (and
                        (tipoUnid ?u ?tu)
                        (tipoEdif ?e ?te)
                        (edifReclu ?tu ?te)
                        (>= (almacen Gas) (requiere ?tu Gas))
                        (>= (almacen Minerales) (requiere ?tu Minerales))
                    )
                )
            )
        ;;unidad creada y en la posicion x
        :effect
            (and
                (unidEn ?u ?x)
                (existe ?u)
                (forall (?tu - tipoUni)
                    (when (tipoUnid ?u ?tu)
                        (and
                            (decrease (almacen Gas) (requiere ?tu Gas))
                            (decrease (almacen Minerales) (requiere ?tu Minerales))
                        )
                    )
                )
                (when (tipoUnid ?u VCE)
                    (increase (tiempoTranscurrido) (tiempoUnid VCE))
                )
                (when (tipoUnid ?u Marine)
                    (increase (tiempoTranscurrido) (tiempoUnid Marine))
                )
                (when (tipoUnid ?u Soldado)
                    (increase (tiempoTranscurrido) (tiempoUnid Soldado))
                )
            )
    )

    (:action recolectar
        :parameters (?r - recursos ?x - localizacion)
        :precondition
            (and
                (nodo ?r ?x)
                (exists (?u - unidades)
                    (and
                        (unidEn ?u ?x)
                        (extrayendo ?u ?r)
                    )
                )
                (exists (?tr - tipoRecur)
                    (and
                        (tipoRecur ?r ?tr)
                        (<= (+ (almacen ?tr) (deposVCE ?tr)) 60)
                    )
                )
            )
        :effect
            (and
                (forall(?tr - tipoRecur)
                    (when(tipoRecur ?r ?tr)
                        (increase (almacen ?tr) (deposVCE ?tr))
                    )
                )
                (increase (tiempoTranscurrido) (tiempoRecolectar))
            )
    )
)
