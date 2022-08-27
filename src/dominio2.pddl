(define (domain e2-dom)
    (:requirements :strips :typing)
    (:types
        unidades edificios localizacion recursos - object
        tipoUni - unidades
        tipoEdif - edificios
        tipoRecur - recursos
    )
    (:constants
        VCE - tipoUni
        CentroDeMando Barracones Extractor - tipoEdif
        Minerales Gas - tipoRecur
    )
    (:predicates
        (conectado ?x ?y - localizacion)
        (edifEn ?e - edificios ?x - localizacion)
        (unidEn ?u - unidades ?x - localizacion)
        (nodo ?r - recursos ?x - localizacion)
        (extrayendo ?u - unidades ?r - recursos)
        (tipoUnid ?u ?tu - unidades)
        (tipoEdif ?e ?te - edificios)
        (tipoRecur ?r ?tr - recursos)
        (tenemos ?r - recursos)
        (ocupado ?u - unidades)
    )

    (:action navegar
        :parameters (?u - unidades ?x ?y - localizacion)
        :precondition
            (and
                (conectado ?x ?y)
                (unidEn ?u ?x)
                (not(ocupado ?u))
            )
        :effect
            (and
                (unidEn ?u ?y)
                (not(unidEn ?u ?x))
            )
    )

    (:action asignar
        :parameters (?u - unidades ?x - localizacion ?r - recursos)
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
        :effect
            (and
                (extrayendo ?u ?r)
                (ocupado ?u)
                (tenemos ?r)
            )
    )

    (:action construir
        :parameters (?u - unidades ?e - edificios ?x - localizacion ?r - recursos)
        :precondition
            (and
                (unidEn ?u ?x)
                (tipoUnid ?u VCE)
                (tenemos ?r)
                (not(ocupado ?u))
            )
        :effect
            (and
                (edifEn ?e ?x)
            )
    )
)
