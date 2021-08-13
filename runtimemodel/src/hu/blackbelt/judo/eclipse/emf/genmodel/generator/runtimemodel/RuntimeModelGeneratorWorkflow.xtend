package hu.blackbelt.judo.eclipse.emf.genmodel.generator.runtimemodel

import org.eclipse.xtend.lib.annotations.Accessors
import org.eclipse.xtext.generator.GeneratorComponent.Outlet
import org.eclipse.xtext.mwe.ResourceLoadingSlotEntry
import org.eclipse.emf.mwe2.runtime.workflow.AbstractCompositeWorkflowComponent
import hu.blackbelt.eclipse.emf.genmodel.generator.core.engine.GeneratorConfig
import hu.blackbelt.judo.eclipse.emf.genmodel.generator.runtimemodel.engine.RuntimeModelGeneratorStandaloneSetup

@Accessors
class RuntimeModelGeneratorWorkflow extends AbstractCompositeWorkflowComponent {
	
	String javaGenPath
	String modelDir
	String slot = "runtimeModelGenerator"
	Boolean printXmlOnError = false
	
	override preInvoke() {
		val slotEntry = new ResourceLoadingSlotEntry() => [
			setSlot(slot)
		]
		
		val config = new GeneratorConfig() => [
			setJavaGenPath(javaGenPath)
			setPrintXmlOnError(printXmlOnError)
		]
		
		val setup = new RuntimeModelGeneratorStandaloneSetup() => [
			setConfig(config)
			setDoInit(true)
		]

		val readerComponent = new org.eclipse.xtext.mwe.Reader() => [
			addRegister(setup)
			addPath(modelDir)
			addLoadResource(slotEntry)
		]
		
		val outlet = new Outlet() => [
            setPath(javaGenPath)
        ]
		
		val generatorComponent = new org.eclipse.xtext.generator.GeneratorComponent() => [
			setRegister(setup)
			addSlot(slot)
			addOutlet(outlet)
		]

		addComponent(readerComponent)
		addComponent(generatorComponent)
		super.preInvoke
	}
}
