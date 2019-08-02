package hu.blackbelt.judo.eclipse.emf.genmodel.generator.runtimemodel.templates;

import javax.inject.Inject
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess
import org.eclipse.xtext.generator.IGenerator
import org.eclipse.emf.codegen.ecore.genmodel.GenModel

class RuntimeModel implements IGenerator {
	@Inject extension Naming
	
	override doGenerate(Resource input, IFileSystemAccess fsa) {		
		input.allContents.filter(GenModel).forEach[
			val content = generate
			fsa.generateFile(packagePath + "/runtime/" + modelName + "Model.java", content)
		]
	}
	
	def generate (GenModel it) 
	'''
		package «packageName».runtime;
		
		import org.eclipse.emf.common.util.BasicDiagnostic;
		import org.eclipse.emf.common.util.Diagnostic;
		import org.eclipse.emf.common.util.URI;
		import org.eclipse.emf.ecore.EObject;
		import org.eclipse.emf.ecore.resource.Resource;
		import org.eclipse.emf.ecore.resource.ResourceSet;
		import org.eclipse.emf.ecore.resource.URIHandler;
		
		import «packageName».support.«modelName»ModelResourceSupport;
		import org.eclipse.emf.ecore.util.Diagnostician;
		import org.eclipse.emf.ecore.util.EObjectValidator;
		
		import java.io.*;
		import java.nio.charset.Charset;
		import java.util.Collections;
		import java.util.Dictionary;
		import java.util.Hashtable;
		import java.util.Map;
		import java.util.Optional;
		import java.util.Set;
		import java.util.concurrent.ConcurrentHashMap;
		import java.util.function.Function;
		import java.util.function.Predicate;
		import java.util.stream.Collectors;
		
		/**
		 * A wrapper class on a «modelName» metamodel based model. This wrapper organizing the model a structure which can be used
		 * in Tatami as a logical model.
		 * The logical model have version and loaded resources. The logical model can handle load and save from / to different
		 * type of input / output source.
		 *
		 * Examples:
		 *
		 * Load an model from file.
		 * <pre>
		 *    «modelName»Model «modelName.decapitalize»Model = «modelName»Model.load«modelName»Model(«modelName.decapitalize»LoadArgumentsBuilder()
		 *                 .uri(URI.createFileURI(new File("src/test/model/test.«modelName.decapitalize»").getAbsolutePath()))
		 *                 .name("test")
		 *                 .build());
		 *
		 * </pre>
		 *
		 * More complex example, where model is loaded over an {@link URIHandler} in OSGi environment.
		 *
		 * <pre>
		 *
		 *    BundleURIHandler bundleURIHandler = new BundleURIHandler("urn", "", bundleContext.getBundle());
		 *
		 *    «modelName»Model «modelName.decapitalize»Model = «modelName»Model.build«modelName»Model()
		 *                 .name("test")
		 *                 .version("1.0.0")
		 *                 .uri(URI.createURI("urn:test.«modelName.decapitalize»"))
		 *                 .«modelName.decapitalize»ModelResourceSupport(
		 *                         «modelName.decapitalize»ModelResourceSupportBuilder()
		 *                                 .uriHandler(bundleURIHandler)
		 *                                 .build())
		 *                 .metaVersionRange(bundleContext.getBundle().getHeaders().get("[1.0,2))).build();
		 * </pre>
		 *
		 * Create an empty «modelName.decapitalize» model
		 * <pre>
		 *    «modelName»Model «modelName.decapitalize»Model = «modelName»Model.build«modelName»Model()
		 *                 .name("test")
		 *                 .uri(URI.createFileURI("test.model"))
		 *                 .build()
		 * </pre>
		 *
		 */
		public class «modelName»Model {
		
		    public static Diagnostician diagnostician = new Diagnostician();
		
		    public static final String NAME = "name";
		    public static final String VERSION = "version";
		    public static final String CHECKSUM = "checksum";
		    public static final String META_VERSION_RANGE = "meta-version-range";
		    public static final String URI = "uri";
		    public static final String RESOURCESET = "resourceset";
		    String name;
		    String version;
		    URI uri;
		    String checksum;
		    String metaVersionRange;
		    «modelName»ModelResourceSupport «modelName.decapitalize»ModelResourceSupport;
		
		    /**
		     * Return all properties as a {@link Dictionary}
		     * @return
		     */
		    public Dictionary<String, Object> toDictionary() {
		        Dictionary<String, Object> ret = new Hashtable<>();
		        ret.put(NAME, name);
		        ret.put(VERSION, version);
		        ret.put(URI, uri);
		        ret.put(CHECKSUM, checksum);
		        ret.put(META_VERSION_RANGE, metaVersionRange);
		        ret.put(RESOURCESET, «modelName.decapitalize»ModelResourceSupport.getResourceSet());
		        return ret;
		    }
		
		    /**
		     * Get the model's isolated {@link ResourceSet}
		     * @return
		     */
		    public ResourceSet getResourceSet() {
		        return «modelName.decapitalize»ModelResourceSupport.getResourceSet();
		    }
		
		
		    /**
		     * Get the model's root resource which represents the mdoel's uri {@link URI} itself.
		     * If the given resource does not exists new one is created.
		     * @return
		     */
		    public Resource getResource() {
		        if (getResourceSet().getResource(uri, false) == null) {
		            getResourceSet().createResource(uri);
		        }
		        return getResourceSet().getResource(uri, false);
		    }
		
		    /**
		     * Load an model. {@link LoadArguments.LoadArgumentsBuilder} contains all parameter
		     * @param loadArgumentsBuilder
		     * @return
		     * @throws IOException
		     */
		    public static «modelName»Model load«modelName»Model(LoadArguments.LoadArgumentsBuilder loadArgumentsBuilder) throws IOException {
		        return load«modelName»Model(loadArgumentsBuilder.build());
		    }
		
		    /**
		     * Load an model. {@link LoadArguments} contains all parameter
		     * @param loadArguments
		     * @return
		     * @throws IOException
		     */
		    public static «modelName»Model load«modelName»Model(LoadArguments loadArguments) throws IOException {
		        «modelName»ModelResourceSupport «modelName.decapitalize»ModelResourceSupport = loadArguments.«modelName.decapitalize»ModelResourceSupport.orElseGet(() -> «modelName»ModelResourceSupport.«modelName.decapitalize»ModelResourceSupportBuilder()
		        	.resourceSet(loadArguments.resourceSet.orElse(null))
		        	.rootUri(loadArguments.rootUri).uriHandler(loadArguments.uriHandler)
		        	.build());
		        «modelName»ModelBuilder b = «modelName»Model.build«modelName»Model();
		        b.name(loadArguments.name)
		        	.version(loadArguments.version.orElse("1.0.0"))
		        	.uri(loadArguments.uri)
		        	.checksum(loadArguments.checksum.orElse("NON-DEFINED"))
		        	.«modelName.decapitalize»ModelResourceSupport(«modelName.decapitalize»ModelResourceSupport)
		        	.metaVersionRange(loadArguments.acceptedMetaVersionRange.orElse("[0,9999)"));
		        «modelName»Model «modelName.decapitalize»Model = b.build();
		        Resource resource = «modelName.decapitalize»Model.getResourceSet().createResource(loadArguments.uri);
		        resource.load(loadArguments.loadOptions.orElse(«modelName»ModelResourceSupport.get«modelName»ModelDefaultLoadOptions()));
		        «modelName»ModelResourceSupport.setupRelativeUriRoot(«modelName.decapitalize»Model.getResourceSet(), loadArguments.uri);
		        return «modelName.decapitalize»Model;
		    }
		
		    /**
		     * Save the model to the given URI.
		     * @throws IOException
		     */
		    public void save«modelName»Model() throws IOException {
		        getResourceSet().getResource(getUri(), false).save(«modelName»ModelResourceSupport.get«modelName»ModelDefaultSaveOptions());
		    }
		
		    /**
		     * Save the model as the given {@link SaveArguments.SaveArgumentsBuilder} defines
		     * @param saveArgumentsBuilder
		     * @throws IOException
		     */
		    public void save«modelName»Model(SaveArguments.SaveArgumentsBuilder saveArgumentsBuilder) throws IOException {
		        save«modelName»Model(saveArgumentsBuilder.build());
		    }
		
		    /**
		     * Save the model as the given {@link SaveArguments} defines
		     * @param saveArguments
		     * @throws IOException
		     */
		    public void save«modelName»Model(SaveArguments saveArguments) throws IOException {
		        try {
		            OutputStream outputStream = saveArguments.outputStream.orElseGet(() -> saveArguments.file.map(f -> {
		                try {
		                    return new FileOutputStream(f);
		                } catch (FileNotFoundException e) {
		                    throw new RuntimeException(e);
		                }
		            }).orElse(null));
		            getResourceSet().getResource(getUri(), false).save(outputStream, 
		            	saveArguments.saveOptions.orElseGet(() -> «modelName»ModelResourceSupport.get«modelName»ModelDefaultSaveOptions()));
		        } catch (RuntimeException e) {
		            if (e.getCause() instanceof IOException) {
		                throw (IOException) e.getCause();
		            } else {
		                throw e;
		            }
		        }
		    }
		
		    private Diagnostic getDiagnostic(EObject eObject) {
		        BasicDiagnostic diagnostics = new BasicDiagnostic
		                (EObjectValidator.DIAGNOSTIC_SOURCE,
		                        0,
		                        String.format("Diagnosis of %s\n", new Object[] { diagnostician.getObjectLabel(eObject) }),
		                        new Object [] { eObject });
		        diagnostician.validate(eObject, diagnostics, diagnostician.createDefaultContext());
		        return diagnostics;
		    }
		
		    private static <T> Predicate<T> distinctByKey(
		            Function<? super T, ?> keyExtractor) {
		
		        Map<Object, Boolean> seen = new ConcurrentHashMap<>();
		        return t -> seen.putIfAbsent(keyExtractor.apply(t), Boolean.TRUE) == null;
		    }
		
		    /**
		     * Get distinct diagnostics for model. Only  {@link Diagnostic}.WARN and {@link Diagnostic}.ERROR are returns.
		     * @return
		     */
		    public Set<Diagnostic> getDiagnostics() {
		        return get«modelName»ModelResourceSupport().all()
		                .filter(EObject.class :: isInstance)
		                .map(EObject.class :: cast)
		                .map(e -> getDiagnostic(e))
		                .filter(d -> d.getSeverity() > Diagnostic.INFO)
		                .filter(d -> d.getChildren().size() > 0)
		                .flatMap(d -> d.getChildren().stream())
		                .filter(distinctByKey(e -> e.toString()))
		                .collect(Collectors.toSet());
		    }
		
		    /**
		     * Checks the model have any {@link Diagnostic}.ERROR diagnostics. When there is no any the model assumed as valid.
		     * @return
		     */
		    public boolean isValid() {
		        Set<Diagnostic> diagnostics = getDiagnostics();
		        return !diagnostics.stream().filter(e -> e.getSeverity() >= Diagnostic.ERROR).findAny().isPresent();
		    }
		
		    /**
		     * Print model as string
		     * @return
		     */
		    public String asString() {
		        ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
		        try {
		            save«modelName»Model(SaveArguments.«modelName.decapitalize»SaveArgumentsBuilder().outputStream(byteArrayOutputStream).build());
		            getResourceSet().getResource(getUri(), false).save(byteArrayOutputStream, Collections.EMPTY_MAP);
		        } catch (IOException e) {
		        }
		        return new String(byteArrayOutputStream.toByteArray(), Charset.defaultCharset());
		    }
		
		    /**
		     * Get diagnostics as a String
		     * @return
		     */
		    public String getDiagnosticsAsString() {
		        return getDiagnostics().stream().map(d -> d.toString()).collect(Collectors.joining("\n"));
		    }
		
		    /**
		     * Arguments for {@link «modelName»Model#load«modelName»Model(LoadArguments)}
		     * It can handle variance of the presented arguments.
		     */
		    public static class LoadArguments {
		        URI uri;
		        String name;
		        Optional<«modelName»ModelResourceSupport> «modelName.decapitalize»ModelResourceSupport;
		        Optional<URI> rootUri;
		        Optional<URIHandler> uriHandler;
		        Optional<ResourceSet> resourceSet;
		        Optional<String> version;
		        Optional<String> checksum;
		        Optional<String> acceptedMetaVersionRange;
		        Optional<Map<Object, Object>> loadOptions;
		
		        @java.lang.SuppressWarnings("all")
		        private static Optional<«modelName»ModelResourceSupport> $default$«modelName.decapitalize»ModelResourceSupport() {
		            return Optional.empty();
		        }
		
		        @java.lang.SuppressWarnings("all")
		        private static Optional<URI> $default$rootUri() {
		            return Optional.empty();
		        }
		
		        @java.lang.SuppressWarnings("all")
		        private static Optional<URIHandler> $default$uriHandler() {
		            return Optional.empty();
		        }
		
		        @java.lang.SuppressWarnings("all")
		        private static Optional<ResourceSet> $default$resourceSet() {
		            return Optional.empty();
		        }
		
		        @java.lang.SuppressWarnings("all")
		        private static Optional<String> $default$version() {
		            return Optional.empty();
		        }
		
		        @java.lang.SuppressWarnings("all")
		        private static Optional<String> $default$checksum() {
		            return Optional.empty();
		        }
		
		        @java.lang.SuppressWarnings("all")
		        private static Optional<String> $default$acceptedMetaVersionRange() {
		            return Optional.empty();
		        }
		
		        @java.lang.SuppressWarnings("all")
		        private static Optional<Map<Object, Object>> $default$loadOptions() {
		            return Optional.of(«modelName»ModelResourceSupport.get«modelName»ModelDefaultLoadOptions());
		        }
		
		
		        @java.lang.SuppressWarnings("all")
		        /**
		         * Builder for {@link «modelName»Model#load«modelName»Model(LoadArguments)}.
		         */
		        public static class LoadArgumentsBuilder {
		            @java.lang.SuppressWarnings("all")
		            private URI uri;
		            @java.lang.SuppressWarnings("all")
		            private String name;
		            @java.lang.SuppressWarnings("all")
		            private boolean «modelName.decapitalize»ModelResourceSupport$set;
		            @java.lang.SuppressWarnings("all")
		            private Optional<«modelName»ModelResourceSupport> «modelName.decapitalize»ModelResourceSupport;
		            @java.lang.SuppressWarnings("all")
		            private boolean rootUri$set;
		            @java.lang.SuppressWarnings("all")
		            private Optional<URI> rootUri;
		            @java.lang.SuppressWarnings("all")
		            private boolean uriHandler$set;
		            @java.lang.SuppressWarnings("all")
		            private Optional<URIHandler> uriHandler;
		            @java.lang.SuppressWarnings("all")
		            private boolean resourceSet$set;
		            @java.lang.SuppressWarnings("all")
		            private Optional<ResourceSet> resourceSet;
		            @java.lang.SuppressWarnings("all")
		            private boolean version$set;
		            @java.lang.SuppressWarnings("all")
		            private Optional<String> version;
		            @java.lang.SuppressWarnings("all")
		            private boolean checksum$set;
		            @java.lang.SuppressWarnings("all")
		            private Optional<String> checksum;
		            @java.lang.SuppressWarnings("all")
		            private boolean acceptedMetaVersionRange$set;
		            @java.lang.SuppressWarnings("all")
		            private Optional<String> acceptedMetaVersionRange;
		            @java.lang.SuppressWarnings("all")
		            private boolean loadOptions$set;
		            @java.lang.SuppressWarnings("all")
		            private Optional<Map<Object, Object>> loadOptions;
		
		            @java.lang.SuppressWarnings("all")
		            LoadArgumentsBuilder() {
		            }
		
		            @java.lang.SuppressWarnings("all")
		            /**
		             * Defines the {@link URI} of the model.
		             * This is mandatory.
		             */
		            public LoadArgumentsBuilder uri(final URI uri) {
		                this.uri = uri;
		                return this;
		            }
		
		            @java.lang.SuppressWarnings("all")
		            /**
		             * Defines the name of the model.
		             * This is mandatory.
		             */
		            public LoadArgumentsBuilder name(final String name) {
		                this.name = name;
		                return this;
		            }
		
		            @java.lang.SuppressWarnings("all")
		            /**
		             * Defines the {@link «modelName»ModelResourceSupport} for model.
		             * If its not defined a default one is created based on default {@link ResourceSet}
		             */
		            public LoadArgumentsBuilder «modelName.decapitalize»ModelResourceSupport(final «modelName»ModelResourceSupport «modelName.decapitalize»ModelResourceSupport) {
		                this.«modelName.decapitalize»ModelResourceSupport = Optional.of(«modelName.decapitalize»ModelResourceSupport);
		                «modelName.decapitalize»ModelResourceSupport$set = true;
		                return this;
		            }
		
		            @java.lang.SuppressWarnings("all")
		            /**
		             * Defines the root uri {@link URI} for model.
		             * If its not defined a default one is created based on the main resource.
		             */
		            public LoadArgumentsBuilder rootUri(final URI rootUri) {
		                this.rootUri = Optional.of(rootUri);
		                rootUri$set = true;
		                return this;
		            }
		
		            @java.lang.SuppressWarnings("all")
		            /**
		             * Defines the {@link URIHandler} used for model IO. If not defined the default is EMF used.
		             */
		            public LoadArgumentsBuilder uriHandler(final URIHandler uriHandler) {
		                this.uriHandler = Optional.of(uriHandler);
		                uriHandler$set = true;
		                return this;
		            }
		
		            @java.lang.SuppressWarnings("all")
		            /**
		             * Defines the default {@link ResourceSet}. If it is not defined the factory based resourceSet is used.
		             */
		            public LoadArgumentsBuilder resourceSet(final ResourceSet resourceSet) {
		                this.resourceSet = Optional.of(resourceSet);
		                resourceSet$set = true;
		                return this;
		            }
		
		            @java.lang.SuppressWarnings("all")
		            /**
		             * Defines the model version. If its not defined the version will be 1.0.0
		             */
		            public LoadArgumentsBuilder version(final String version) {
		                this.version = Optional.of(version);
		                version$set = true;
		                return this;
		            }
		
		            @java.lang.SuppressWarnings("all")
		            /**
		             * Defines the model checksum. If its not defined 'notused' is defined.
		             */
		            public LoadArgumentsBuilder checksum(final String checksum) {
		                this.checksum = Optional.of(checksum);
		                checksum$set = true;
		                return this;
		            }
		
		            @java.lang.SuppressWarnings("all")
		            /**
		             * Defines the accepted version range of the meta model. If its not defined [1.0,2) is used.
		             */
		            public LoadArgumentsBuilder acceptedMetaVersionRange(final String acceptedMetaVersionRange) {
		                this.acceptedMetaVersionRange = Optional.of(acceptedMetaVersionRange);
		                acceptedMetaVersionRange$set = true;
		                return this;
		            }
		
		            @java.lang.SuppressWarnings("all")
		            /**
		             * Defines the load options for model. If not defined the {@link «modelName»Model#get«modelName»ModelDefaultLoadOptions()} us used.
		             */
		            public LoadArgumentsBuilder loadOptions(final Map<Object, Object> loadOptions) {
		                this.loadOptions = Optional.of(loadOptions);
		                loadOptions$set = true;
		                return this;
		            }
		
		            @java.lang.SuppressWarnings("all")
		            public LoadArguments build() {
		                Optional<«modelName»ModelResourceSupport> «modelName.decapitalize»ModelResourceSupport = this.«modelName.decapitalize»ModelResourceSupport;
		                if (!«modelName.decapitalize»ModelResourceSupport$set) «modelName.decapitalize»ModelResourceSupport = LoadArguments.$default$«modelName.decapitalize»ModelResourceSupport();
		                Optional<URI> rootUri = this.rootUri;
		                if (!rootUri$set) rootUri = LoadArguments.$default$rootUri();
		                Optional<URIHandler> uriHandler = this.uriHandler;
		                if (!uriHandler$set) uriHandler = LoadArguments.$default$uriHandler();
		                Optional<ResourceSet> resourceSet = this.resourceSet;
		                if (!resourceSet$set) resourceSet = LoadArguments.$default$resourceSet();
		                Optional<String> version = this.version;
		                if (!version$set) version = LoadArguments.$default$version();
		                Optional<String> checksum = this.checksum;
		                if (!checksum$set) checksum = LoadArguments.$default$checksum();
		                Optional<String> acceptedMetaVersionRange = this.acceptedMetaVersionRange;
		                if (!acceptedMetaVersionRange$set) acceptedMetaVersionRange = LoadArguments.$default$acceptedMetaVersionRange();
		                Optional<Map<Object, Object>> loadOptions = this.loadOptions;
		                if (!loadOptions$set) loadOptions = LoadArguments.$default$loadOptions();
		                return new LoadArguments(uri, name, «modelName.decapitalize»ModelResourceSupport, rootUri, uriHandler, resourceSet, version, checksum, acceptedMetaVersionRange, loadOptions);
		            }
		
		            @java.lang.Override
		            @java.lang.SuppressWarnings("all")
		            public java.lang.String toString() {
		                return "«modelName»Model.LoadArguments.LoadArgumentsBuilder(uri=" + this.uri 
		                	+ ", name=" + this.name 
		                	+ ", «modelName.decapitalize»ModelResourceSupport=" + this.«modelName.decapitalize»ModelResourceSupport 
		                	+ ", rootUri=" + this.rootUri 
		                	+ ", uriHandler=" + this.uriHandler 
		                	+ ", resourceSet=" + this.resourceSet 
		                	+ ", version=" + this.version 
		                	+ ", checksum=" + this.checksum 
		                	+ ", acceptedMetaVersionRange=" + this.acceptedMetaVersionRange 
		                	+ ", loadOptions=" + this.loadOptions + ")";
		            }
		        }
		
		        @java.lang.SuppressWarnings("all")
		        public static LoadArgumentsBuilder «modelName.decapitalize»LoadArgumentsBuilder() {
		            return new LoadArgumentsBuilder();
		        }
		
		        @java.lang.SuppressWarnings("all")
		        private LoadArguments(final URI uri, 
				        	final String name, 
				        	final Optional<«modelName»ModelResourceSupport> «modelName.decapitalize»ModelResourceSupport, 
				        	final Optional<URI> rootUri, 
				        	final Optional<URIHandler> uriHandler, 
				        	final Optional<ResourceSet> resourceSet, 
				        	final Optional<String> version, 
				        	final Optional<String> checksum, 
				        	final Optional<String> acceptedMetaVersionRange, 
				        	final Optional<Map<Object, Object>> loadOptions) {
		            this.uri = uri;
		            this.name = name;
		            this.«modelName.decapitalize»ModelResourceSupport = «modelName.decapitalize»ModelResourceSupport;
		            this.rootUri = rootUri;
		            this.uriHandler = uriHandler;
		            this.resourceSet = resourceSet;
		            this.version = version;
		            this.checksum = checksum;
		            this.acceptedMetaVersionRange = acceptedMetaVersionRange;
		            this.loadOptions = loadOptions;
		        }
		    }
		
		
		    /**
		     * Arguments for {@link «modelName»Model#save«modelName»Model(SaveArguments)}
		     * It can handle variance of the presented arguments.
		     */
		    public static class SaveArguments {
		        Optional<OutputStream> outputStream;
		        Optional<File> file;
		        Optional<Map<Object, Object>> saveOptions;
		
		        @java.lang.SuppressWarnings("all")
		        private static Optional<OutputStream> $default$outputStream() {
		            return Optional.empty();
		        }
		
		        @java.lang.SuppressWarnings("all")
		        private static Optional<File> $default$file() {
		            return Optional.empty();
		        }
		
		        @java.lang.SuppressWarnings("all")
		        private static Optional<Map<Object, Object>> $default$saveOptions() {
		            return Optional.empty();
		        }
		
		
		        @java.lang.SuppressWarnings("all")
		        /**
		         * Builder for {@link «modelName»Model#save«modelName»Model(SaveArguments)}.
		         */
		        public static class SaveArgumentsBuilder {
		            @java.lang.SuppressWarnings("all")
		            private boolean outputStream$set;
		            @java.lang.SuppressWarnings("all")
		            private Optional<OutputStream> outputStream;
		            @java.lang.SuppressWarnings("all")
		            private boolean file$set;
		            @java.lang.SuppressWarnings("all")
		            private Optional<File> file;
		            @java.lang.SuppressWarnings("all")
		            private boolean saveOptions$set;
		            @java.lang.SuppressWarnings("all")
		            private Optional<Map<Object, Object>> saveOptions;
		
		            @java.lang.SuppressWarnings("all")
		            SaveArgumentsBuilder() {
		            }
		
		            @java.lang.SuppressWarnings("all")
		            /**
		             * Defines {@link OutputStream} which is used by save. Whe it is not defined, file is used.
		             */
		            public SaveArgumentsBuilder outputStream(final OutputStream outputStream) {
		                this.outputStream = Optional.of(outputStream);
		                outputStream$set = true;
		                return this;
		            }
		
		            @java.lang.SuppressWarnings("all")
		            /**
		             * Defines {@link File} which is used by save. Whe it is not defined the model's {@link «modelName»Model#uri is used}
		             */
		            public SaveArgumentsBuilder file(File file) {
		                this.file = Optional.of(file);
		                file$set = true;
		                return this;
		            }
		
		            @java.lang.SuppressWarnings("all")
		            /**
		             * Defines save options. When it is not defined {@link «modelName»ModelResourceSupport#get«modelName»ModelDefaultSaveOptions()} is used.
		             */
		            public SaveArgumentsBuilder saveOptions(final Map<Object, Object> saveOptions) {
		                this.saveOptions = Optional.of(saveOptions);
		                saveOptions$set = true;
		                return this;
		            }
		
		            @java.lang.SuppressWarnings("all")
		            public SaveArguments build() {
		                Optional<OutputStream> outputStream = this.outputStream;
		                if (!outputStream$set) outputStream = SaveArguments.$default$outputStream();
		                Optional<File> file = this.file;
		                if (!file$set) file = SaveArguments.$default$file();
		                Optional<Map<Object, Object>> saveOptions = this.saveOptions;
		                if (!saveOptions$set) saveOptions = SaveArguments.$default$saveOptions();
		                return new SaveArguments(outputStream, file, saveOptions);
		            }
		
		            @java.lang.Override
		            @java.lang.SuppressWarnings("all")
		            public java.lang.String toString() {
		                return "«modelName»Model.SaveArguments.SaveArgumentsBuilder(outputStream=" + this.outputStream + ", file=" + this.file + ", saveOptions=" + this.saveOptions + ")";
		            }
		        }
		
		        @java.lang.SuppressWarnings("all")
		        public static SaveArgumentsBuilder «modelName.decapitalize»SaveArgumentsBuilder() {
		            return new SaveArgumentsBuilder();
		        }
		
		        @java.lang.SuppressWarnings("all")
		        private SaveArguments(final Optional<OutputStream> outputStream, final Optional<File> file, final Optional<Map<Object, Object>> saveOptions) {
		            this.outputStream = outputStream;
		            this.file = file;
		            this.saveOptions = saveOptions;
		        }
		    }
		
		
		    @java.lang.SuppressWarnings("all")
		    public static class «modelName»ModelBuilder {
		        @java.lang.SuppressWarnings("all")
		        private String name;
		        @java.lang.SuppressWarnings("all")
		        private URI uri;
		
		        @java.lang.SuppressWarnings("all")
		        private boolean version$set;
		        @java.lang.SuppressWarnings("all")
		        private Optional<String> version;
		        @java.lang.SuppressWarnings("all")
		        private boolean checksum$set;
		        @java.lang.SuppressWarnings("all")
		        private Optional<String> checksum;
		
		        @java.lang.SuppressWarnings("all")
		        private boolean metaVersionRange$set;
		        @java.lang.SuppressWarnings("all")
		        private Optional<String> metaVersionRange;
		
		        @java.lang.SuppressWarnings("all")
		        private boolean «modelName.decapitalize»ModelResourceSupport$set;
		        @java.lang.SuppressWarnings("all")
		        private Optional<«modelName»ModelResourceSupport> «modelName.decapitalize»ModelResourceSupport;
		
		        @java.lang.SuppressWarnings("all")
		        «modelName»ModelBuilder() {
		        }
		
		        @java.lang.SuppressWarnings("all")
		        /**
		         * Defines name of the model. Its mandatory.
		         */
		        public «modelName»ModelBuilder name(final String name) {
		            this.name = name;
		            return this;
		        }
		
		        @java.lang.SuppressWarnings("all")
		        /**
		         * Defines the uri {@link URI} of the model. Its mandatory.
		         */
		        public «modelName»ModelBuilder uri(final URI uri) {
		            this.uri = uri;
		            return this;
		        }
		
		        @java.lang.SuppressWarnings("all")
		        /**
		         * Defines the version of the model. Its mandatory.
		         */
		        public «modelName»ModelBuilder version(final String version) {
		            this.version = Optional.of(version);
		            version$set = true;
		            return this;
		        }
		
		        @java.lang.SuppressWarnings("all")
		        /**
		         * Defines the checksum of the model. Its mandatory.
		         */
		        public «modelName»ModelBuilder checksum(final String checksum) {
		            this.checksum = Optional.of(checksum);
		            this.checksum$set = true;
		            return this;
		        }
		
		        @java.lang.SuppressWarnings("all")
		        /**
		         * Defines the version of the model.
		         */
		        public «modelName»ModelBuilder metaVersionRange(final String metaVersionRange) {
		            this.metaVersionRange = Optional.of(metaVersionRange);
		            this.metaVersionRange$set = true;
		            return this;
		        }
		
		        @java.lang.SuppressWarnings("all")
		        public «modelName»ModelBuilder «modelName.decapitalize»ModelResourceSupport(final «modelName»ModelResourceSupport «modelName.decapitalize»ModelResourceSupport) {
		            this.«modelName.decapitalize»ModelResourceSupport = Optional.of(«modelName.decapitalize»ModelResourceSupport);
		            this.«modelName.decapitalize»ModelResourceSupport$set = true;
		            return this;
		        }
		
		        @java.lang.SuppressWarnings("all")
		        public «modelName»Model build() {
		
		            Optional<«modelName»ModelResourceSupport> «modelName.decapitalize»ModelResourceSupport = this.«modelName.decapitalize»ModelResourceSupport;
		            if (!«modelName.decapitalize»ModelResourceSupport$set) «modelName.decapitalize»ModelResourceSupport = LoadArguments.$default$«modelName.decapitalize»ModelResourceSupport();
		            Optional<String> version = this.version;
		            if (!version$set) version = LoadArguments.$default$version();
		            Optional<String> checksum = this.checksum;
		            if (!checksum$set) checksum = LoadArguments.$default$checksum();
		            Optional<String> metaVersionRange = this.metaVersionRange;
		            if (!metaVersionRange$set) metaVersionRange = LoadArguments.$default$acceptedMetaVersionRange();
		
		            return new «modelName»Model(name, version, uri, checksum, metaVersionRange, «modelName.decapitalize»ModelResourceSupport);
		        }
		
		        @java.lang.Override
		        @java.lang.SuppressWarnings("all")
		        public java.lang.String toString() {
		            return "«modelName»Model.«modelName»ModelBuilder(name=" + this.name 
		            	+ ", version=" + this.version 
		            	+ ", uri=" + this.uri 
		            	+ ", checksum=" + this.checksum 
		            	+ ", metaVersionRange=" + this.metaVersionRange 
		            	+ ", «modelName.decapitalize»ModelResourceSupport=" + this.«modelName.decapitalize»ModelResourceSupport + ")";
		        }
		    }
		
		    @java.lang.SuppressWarnings("all")
		    public static «modelName»ModelBuilder build«modelName»Model() {
		        return new «modelName»ModelBuilder();
		    }
		
		
		    @java.lang.SuppressWarnings("all")
		    private static Optional<«modelName»ModelResourceSupport> $default$«modelName.decapitalize»ModelResourceSupport() {
		        return Optional.empty();
		    }
		
		    @java.lang.SuppressWarnings("all")
		    private static Optional<String> $default$version() {
		        return Optional.empty();
		    }
		
		    @java.lang.SuppressWarnings("all")
		    private static Optional<String> $default$checksum() {
		        return Optional.empty();
		    }
		
		    @java.lang.SuppressWarnings("all")
		    private static Optional<String> $default$metaVersionRange() {
		        return Optional.empty();
		    }
		
		    @java.lang.SuppressWarnings("all")
		    private «modelName»Model(final String name, 
		    			final Optional<String> version, 
		    			final URI uri, 
		    			final Optional<String> checksum, 
		    			final Optional<String> metaVersionRange, 
		    			final Optional<«modelName»ModelResourceSupport> «modelName.decapitalize»ModelResourceSupport) {
		        this.name = name;
		        this.version = version.orElse("1.0.0");
		        this.uri = uri;
		        this.checksum = checksum.orElse("notused");
		        this.metaVersionRange = metaVersionRange.orElse("[1.0,2)");
		        this.«modelName.decapitalize»ModelResourceSupport = «modelName.decapitalize»ModelResourceSupport.orElse(«modelName»ModelResourceSupport.«modelName.decapitalize»ModelResourceSupportBuilder().resourceSet(«modelName»ModelResourceSupport.create«modelName»ResourceSet()).build());
		    }
		
		    @java.lang.Override
		    @java.lang.SuppressWarnings("all")
		    public java.lang.String toString() {
		        return "«modelName»Model(name=" + this.getName() 
			        + ", version=" + this.getVersion() 
			        + ", uri=" + this.getUri() 
			        + ", checksum=" + this.getChecksum() 
			        + ", metaVersionRange=" + this.getMetaVersionRange() 
			        + ", «modelName.decapitalize»ModelResourceSupport=" + this.get«modelName»ModelResourceSupport() + ")";
		    }
		
		    @java.lang.SuppressWarnings("all")
		    /**
		     * Get the name of the model.
		     */
		    public String getName() {
		        return this.name;
		    }
		
		    @java.lang.SuppressWarnings("all")
		    /**
		     * Get the model version.
		     */
		    public String getVersion() {
		        return this.version;
		    }
		
		    @java.lang.SuppressWarnings("all")
		    /**
		     * Get the {@link URI} of the model.
		     */
		    public URI getUri() {
		        return this.uri;
		    }
		
		    @java.lang.SuppressWarnings("all")
		    /**
		     * Get the checksum of the model.
		     */
		    public String getChecksum() {
		        return this.checksum;
		    }
		
		    @java.lang.SuppressWarnings("all")
		    /**
		     * Get the accepted range of meta model version.
		     */
		    public String getMetaVersionRange() {
		        return this.metaVersionRange;
		    }
		
		    @java.lang.SuppressWarnings("all")
		    /**
		     * Get the {@link «modelName»ModelResourceSupport} instance related this instance.
		     */
		    public «modelName»ModelResourceSupport get«modelName»ModelResourceSupport() {
		        return this.«modelName.decapitalize»ModelResourceSupport;
		    }
		}
	'''
}