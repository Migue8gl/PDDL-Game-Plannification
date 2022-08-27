(define (domain e3-dom)
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
        (conectado ?x ?y - localizacion) ;;si dos localizaciones son navegables de izq a der
        (edifEn ?e - edificios ?x - localizacion) ;;si el edificio e está construido en x
        (unidEn ?u - unidades ?x - localizacion);;si la unidad u está en x
        (construido ?x - localizacion);;si hay algún edificio en x
        (nodo ?r - recursos ?x - localizacion);;se asigna nodo de recurso r a x
        (extrayendo ?u - unidades ?r - recursos);;unidad u extrayendo recurso r
        (tipoUnid ?u - unidades ?tu - tipoUni);;tipo de unidad
        (tipoEdif ?e - edificios  ?te - tipoEdif);;tipo de edificio
        (tipoRecur ?r - recursos ?tr - tipoRecur);;tipo de recurso
        (necesita ?e - edificios ?r - recursos);;el edificio e necesita recurso r
        (ocupado ?u - unidades);;la unidad un está ocupada
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
        :effect
            (and
                (unidEn ?u ?y)
                (not(unidEn ?u ?x))
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
                (unidEn ?u ?x)
                (not(ocupado ?u))
                (not(edifEn ?e ?x))
                (not(construido ?x))
                (not(edifConstruido ?e))
                (tipoUnid ?u VCE)
                (exists (?te - tipoEdif) 
                   (and 
                        (tipoEdif ?e ?te)
                        (forall (?r - recursos)
                            (imply (necesita ?te ?r) (exists (?u2 - unidades) (extrayendo ?u2 ?r)))
                        )
                    )
                )     
            )
        ;;el edificio es construido en x, x está ocupada
        :effect
            (and
                (construido ?x)
                (edifEn ?e ?x)
                (edifConstruido ?e)
            )
    )
)
