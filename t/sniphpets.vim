describe "sniphpets#fqn"

    it "Should resolve a FQN for the current buffer"
        silent file! /home/sniphpets/src/App/Post.php

        let fqn = sniphpets#fqn()

        Expect fqn == 'App\Post'
    end

    it "Should use a phpactor to resolve a FQN if the phactor plugin installed"
        runtime! t/mocks/plugin/phpactor.vim
        let g:phpactor_fqn = 'App\Test'

        let fqn = sniphpets#fqn()

        Expect fqn == 'App\Test'
    end

    it "Should resolve a FQN by itself if the phactor fails"
        let g:phpactor_fqn = ''
        silent file! /home/sniphpets/src/App/Entity/Post.php

        let fqn = sniphpets#fqn()

        Expect fqn == 'App\Entity\Post'
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

    it "Should handle slashes properly"
        Expect sniphpets#camel_to_snake('App\Controller') == 'app\controller'
        Expect sniphpets#camel_to_snake('App/Admin/BlogController') == 'app/admin/blog_controller'
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

describe "sniphpets#header"

    it "returns empty string by default"
        Expect sniphpets#header() == ''

        let g:sniphpets_strict_types = 0
        let g:sniphpets_header = ''
        Expect sniphpets#header() == ''
    end

    it "adds strict_types declaration if corresponding variable is set to true"
        let g:sniphpets_strict_types = 1
        Expect stridx(sniphpets#header(), 'declare(strict_types=1);') >= 0
    end

    it "adds custom file-level header if corresponding variable is set"
        let g:sniphpets_header = '/** Test */'
        Expect stridx(sniphpets#header(), g:sniphpets_header) >= 0
    end

    it "adds custom file-level header before strict_types declaration"
        let g:sniphpets_strict_types = 1
        let g:sniphpets_header = '/** Test */'

        let header = sniphpets#header()

        Expect stridx(header, g:sniphpets_header) < stridx(header, 'declare(strict_types=1);')
    end
end

describe "sniphpets#unittest#alternate"

    before
        let g:sniphpets_unittest_namespace = 'Tests?'
        let g:sniphpets_unittest_suffix = 'Test'
    end

    it "should return a proper alternate class for a valid given FQN"
        let class = 'AppBundle\Tests\Utils\SluggerTest'
        let alternate = 'AppBundle\Utils\Slugger'
        Expect sniphpets#unittest#alternate(class) == alternate

        let class = 'Symfony\Bundle\FrameworkBundle\Tests\DependencyInjection\ConfigurationTest'
        let alternate = 'Symfony\Bundle\FrameworkBundle\DependencyInjection\Configuration'
        Expect sniphpets#unittest#alternate(class) == alternate
    end

    it "should return a proper alternate file for a \"short\" FQN"
        let class = 'Tests\AlternateTest'
        let alternate = 'Alternate'
        Expect sniphpets#unittest#alternate(class) == alternate
    end

    it "should return a proper alternate file for a FQN with leading \"\\\""
        let class = '\Tests\AlternateTest'
        let alternate = 'Alternate'
        Expect sniphpets#unittest#alternate(class) == alternate
    end

    it "should return a proper alternate file for a simple class name"
        let class = 'LoggerTest'
        let alternate = 'Logger'
        Expect sniphpets#unittest#alternate(class) == alternate
    end

    it "should return empty string when alternate is not resolved"
        let class = 'AppBundle\Logger\DummyLogger'
        let alternate = ''
        Expect sniphpets#unittest#alternate(class) == alternate

        let class = '\DummyLogger'
        let alternate = ''
        Expect sniphpets#unittest#alternate(class) == alternate
    end

end
