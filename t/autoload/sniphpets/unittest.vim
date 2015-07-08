describe "sniphpets#unittest#resolve_alternate"

    before
        let g:sniphpets_unittest_namespace = 'Tests?'
        let g:sniphpets_unittest_suffix = 'Test'
    end

    it "should return a proper alternate class for a valid given FQN"
        let class = 'AppBundle\Tests\Utils\SluggerTest'
        let alternate = 'AppBundle\Utils\Slugger'
        Expect sniphpets#unittest#resolve_alternate(class) == alternate

        let class = 'Symfony\Bundle\FrameworkBundle\Tests\DependencyInjection\ConfigurationTest'
        let alternate = 'Symfony\Bundle\FrameworkBundle\DependencyInjection\Configuration'
        Expect sniphpets#unittest#resolve_alternate(class) == alternate
    end

    it "should return a proper alternate file for a \"short\" FQN"
        let class = 'Tests\AlternateTest'
        let alternate = 'Alternate'
        Expect sniphpets#unittest#resolve_alternate(class) == alternate
    end

    it "should return a proper alternate file for a FQN with leading \"\\\""
        let class = '\Tests\AlternateTest'
        let alternate = 'Alternate'
        Expect sniphpets#unittest#resolve_alternate(class) == alternate
    end

    it "should return a proper alternate file for a simple class name"
        let class = 'LoggerTest'
        let alternate = 'Logger'
        Expect sniphpets#unittest#resolve_alternate(class) == alternate
    end

    it "should return empty string when alternate is not resolved"
        let class = 'AppBundle\Logger\DummyLogger'
        let alternate = ''
        Expect sniphpets#unittest#resolve_alternate(class) == alternate

        let class = '\DummyLogger'
        let alternate = ''
        Expect sniphpets#unittest#resolve_alternate(class) == alternate
    end

end
