(define (domain e1-dom)
    (:requirements :strips :typing)
    (:types
        unidades edificios localizacion recursos - object
        tipoUni - unidades
        tipoEdif - edificios
        tipoRecur - recursos
    )
    (:constants
        Minerales Gas - tipoRecur
        VCE - tipoUni
        CentroDeMando Barracones - tipoEdif
    )
    (:predicates
        (conectado ?x ?y - localizacion)
        (edifEn ?e - edificios ?x - localizacion)
        (unidEn ?u - unidades ?x - localizacion)
        (construido ?e - edificios)
        (nodo ?r - recursos ?x - localizacion)
        (extrayendo ?u - unidades ?r - recursos)
        (tipoUnid ?u ?tu - unidades)
        (tipoEdif ?e ?te - edificios)
    )

    (:action navegar
        :parameters (?u - unidades ?x ?y - localizacion ?r - recursos)
        :precondition
            (and
                (conectado ?x ?y)
                (unidEn ?u ?x)
                (not(extrayendo ?u ?r))
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
                (not(extrayendo ?u ?r))
            )
        :effect
            (and
                (extrayendo ?u ?r)
            )
    )
)
