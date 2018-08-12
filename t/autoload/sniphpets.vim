describe "sniphpets#resolve_fqn"

    runtime! t/mocks/plugin/phpactor.vim

    it "Should use a phpactor to resolve a FQN if the phactor plugin installed"
        let g:phpactor_fqn = 'FQN'
        let fqn = sniphpets#resolve_fqn()

        Expect fqn == 'FQN'
    end

    it "Should resolve a FQN by itself if the phactor not installed"
        let g:phpactor_fqn = ''
        silent file! /home/sniphpets/src/App/Post.php

        let fqn = sniphpets#resolve_fqn()

        Expect fqn == 'App\Post'
    end

end

describe "sniphpets#path_to_fqn"

    it "Should return a proper FQN for Unix-like paths"
        let path = '/home/user/workspace/my-app/src/AppBundle/Entity/User.php'
        Expect sniphpets#path_to_fqn(path) == 'AppBundle\Entity\User'

        let path = '/home/user/workspace/MyApp/src/AppBundle/Entity/User.php'
        Expect sniphpets#path_to_fqn(path) == 'AppBundle\Entity\User'

        let path = '/home/user/workspace/MyApp/src/folder one/entity/BaseController.php'
        Expect sniphpets#path_to_fqn(path) == 'BaseController'
    end

    it "Should return a proper FQN for Windows-like paths"
        let path = 'C:\Program Files\Windows\PHP\projects\src\MyBundle\Form\FormType.php'
        Expect sniphpets#path_to_fqn(path) == 'MyBundle\Form\FormType'

        let path = 'C:\Program Files\Windows\PHP\projects\src\mYbUNDLe\fORM\XyzClass.php'
        Expect sniphpets#path_to_fqn(path) == 'XyzClass'

        let path = 'C:\Program Files\Windows\PHP\projects\src\Проект\Application.php'
        Expect sniphpets#path_to_fqn(path) == 'Проект\Application'
    end

    it "Should return a class name for a file name"
        Expect sniphpets#path_to_fqn('YiiBase.php') == 'YiiBase'
    end

    it "Should return an empty sting for an empty sting"
        Expect sniphpets#path_to_fqn('') == ''
    end

    it "Should return an empty sting for an ivalid sting"
        Expect sniphpets#path_to_fqn('/crible-crable/abracadabra') == ''
    end

end

describe "sniphpets#camel_to_snake"

    it "Should return a proper snake-case string for a given camel-case string"
        Expect sniphpets#camel_to_snake('IAmACamel') == 'i_am_a_camel'
        Expect sniphpets#camel_to_snake('IAMACAMEL__') == 'i_a_m_a_c_a_m_e_l__'
    end

    it "Should return the same string when a snake-case string given"
        Expect sniphpets#camel_to_snake('im_a_snake') == 'im_a_snake'
        Expect sniphpets#camel_to_snake('239489834') == '239489834'
        Expect sniphpets#camel_to_snake('_') == '_'
    end

    it "Should return an empty sting when an empty sting given"
        Expect sniphpets#camel_to_snake('') == ''
    end

end

describe "sniphpets#head"

    it "Should return a proper string head"
        Expect sniphpets#head('TheHeadOfTheKing', 'Of') == 'TheHead'
        Expect sniphpets#head('HeadNeckKing', 'Neck') == 'Head'
        Expect sniphpets#head('AppBundle\Entity\User', '\') == 'AppBundle'
    end

    it "Should return a proper string head for the 'begin from right' flag"
        Expect sniphpets#head('TheHeadOfTheKingTheLegsOfTheKing', 'TheLegs', 1) == 'TheHeadOfTheKing'
        Expect sniphpets#head('TheHeadOfTheKingTheLegsOfTheKing', 'TheKing', 1) == 'TheHeadOfTheKingTheLegsOf'
        Expect sniphpets#head('AppBundle\Entity\User', '\', 1) == 'AppBundle\Entity'
    end

    it "Should return an empty string when the string does'nt contain the delimiter"
        Expect sniphpets#head('AppBundle\Entity\User', '/') == ''
        Expect sniphpets#head('TheHeadOfTheKingTheLegsOfTheKing', 'B.B.King', 1) == ''
    end

    it "Should return an empty string when an empty string given"
        Expect sniphpets#head('', 'delimiter') == ''
    end

    it "Should return an empty string when an empty delimeter given"
        Expect sniphpets#head('the king of strings', '') == ''
    end

    it "Should return an empty string when an empty string and an empty delimeter given"
        Expect sniphpets#head('', '') == ''
    end

    it "Should return an empty string when the delimiter is equal to the given string"
        Expect sniphpets#head('delimiter', 'delimiter') == ''
    end

end
