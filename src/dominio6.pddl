(define (domain e6-dom)
    (:requirements :strips :typing)
    (:types
        unidades edificios localizacion recursos investigacion cont - object
        tipoUni - unidades 
        tipoEdif - edificios
        tipoRecur - recursos
        tipoInvest - investigacion
    )
    (:constants
        VCE Marine Soldado - tipoUni
        CentroDeMando Barracones Extractor BahiaIngenieria - tipoEdif 
        Minerales Gas - tipoRecur
        InvSoldUni - tipoInvest
    )
    (:functions
        (coste ?c - cont)
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
        (existe ?u - unidades);;si existe esa unidad
        (edifReclu ?tu - tipoUni ?te - tipoEdif);;la unidad se recluta en el edificio e
        (requiere ?u - unidades ?r - recursos);;indica que recurso necesita una unidad para ser creada
        (edifConstruido ?e - edificios);;indica que ese edificio ya está construido
        (necesitaInv ?i - investigacion ?r - recursos);;la investigacion i necesita el recurso r
        (noReclu ?tu - tipoUni);;no se pueden reclutar unidades de tipo tu
        (tipoInvest ?i - investigacion ?ti - tipoInvest);;tipo de investigacion
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
                (increase (coste cont1) 1)
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
                (increase (coste cont1) 1)
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
        ;;el edificio es construido en x y x está ocupada
        :effect
            (and
                (construido ?x)
                (edifConstruido ?e)
                (edifEn ?e ?x)
                (increase (coste cont1) 1)
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
                        (not(noReclu ?tu))
                        (edifReclu ?tu ?te)
                        (forall (?r - recursos)
                            (imply (requiere ?tu ?r) (exists (?u2 - unidades) (extrayendo ?u2 ?r)))
                        )
                    )
                )
            )
        ;;unidad creada y en la posicion x
        :effect
            (and
                (unidEn ?u ?x)
                (existe ?u)
                (increase (coste cont1) 1)
            )
    )

    (:action investigar 
        :parameters (?e - edificios ?i - investigacion)
        :precondition
            (and
                (tipoEdif ?e BahiaIngenieria)
                (edifConstruido ?e)
                (forall (?r - recursos)
                    (and(imply(necesitaInv ?i ?r) (exists (?u2 - unidades) (extrayendo ?u2 ?r))))
                ) 
            )
        :effect
            (and
                (not(noReclu Soldado))
                (increase (coste cont1) 1)
            )
    )
)
