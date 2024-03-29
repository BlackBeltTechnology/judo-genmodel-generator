package hu.blackbelt.judo.eclipse.emf.genmodel.generator.runtimemodel.engine;

/*-
 * #%L
 * hu.blackbelt.judo.eclipse.emf.genmodel.generator.runtimemodel
 * %%
 * Copyright (C) 2018 - 2023 BlackBelt Technology
 * %%
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * This Source Code may also be made available under the following Secondary
 * Licenses when the conditions for such availability set forth in the Eclipse
 * Public License, v. 2.0 are satisfied: GNU General Public License, version 2
 * with the GNU Classpath Exception which is
 * available at https://www.gnu.org/software/classpath/license.html.
 *
 * SPDX-License-Identifier: EPL-2.0 OR GPL-2.0 WITH Classpath-exception-2.0
 * #L%
 */
import com.google.inject.AbstractModule;



import com.google.inject.Module;
import hu.blackbelt.eclipse.emf.genmodel.generator.core.engine.AbstractGenModelGeneratorModule;
import hu.blackbelt.eclipse.emf.genmodel.generator.core.engine.AbstractGenModelGeneratorStandaloneSetup;
import hu.blackbelt.eclipse.emf.genmodel.generator.core.engine.GeneratorConfig;

public class RuntimeModelGeneratorStandaloneSetup extends AbstractGenModelGeneratorStandaloneSetup {

    private RuntimeModelGeneratorConfig runtimeModelGeneratorConfig;

    public void setConfig(RuntimeModelGeneratorConfig runtimeModelGeneratorConfig) {
        this.runtimeModelGeneratorConfig = runtimeModelGeneratorConfig;
    }

    @Override
    public Module getDynamicModule () {
        return new AbstractModule() {
            @Override
            protected void configure() {
                bind(GeneratorConfig.class).toInstance(runtimeModelGeneratorConfig);
                bind(RuntimeModelGeneratorConfig.class).toInstance(runtimeModelGeneratorConfig);
            }
        };
    }


    @Override
    public AbstractGenModelGeneratorModule getGenModelModule() {
        // TODO Auto-generated method stub
        return new RuntimeModelGeneratorModule();
    }
}
