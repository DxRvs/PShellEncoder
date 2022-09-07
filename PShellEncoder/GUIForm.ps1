Class GUIForm{
static [String] $NAME= "PShellEncoder"
static [String] $APP_VERSION=<#_version_#>"1.07b"<#_version_#>
static [string] $icon = "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"
static [xml]$inputMainFormXML=@'
	<Window x:Name="mainW"
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
        xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
        Title="PShellEncoder" Height="600" Width="800" WindowStartupLocation="CenterScreen" ResizeMode="NoResize" FontSize="14">
     <DockPanel>
        <Menu DockPanel.Dock="Top" FontSize="14">
            <MenuItem>
                <MenuItem.Header>File</MenuItem.Header>
                <MenuItem x:Name="MenuItemLoadFile">
                    <MenuItem.Header>Load</MenuItem.Header>
                </MenuItem>
                <MenuItem x:Name="MenuItemSaveResult">
                    <MenuItem.Header>Save</MenuItem.Header>
                </MenuItem>
                <MenuItem  x:Name="MenuItemSetLog">
                    <MenuItem.Header>Set logFile</MenuItem.Header>
                </MenuItem>
                <MenuItem>
                    <MenuItem.Header>Exit</MenuItem.Header>
                </MenuItem>
            </MenuItem>
            <MenuItem>
                <MenuItem.Header>Help</MenuItem.Header>
                <MenuItem x:Name="MenuItemShowAbout">
                    <MenuItem.Header>About</MenuItem.Header>
                </MenuItem>
            </MenuItem>
        </Menu>
        <TabControl x:Name="tabControl"  VerticalAlignment="Top" DockPanel.Dock="Top">
<TabItem Header="Storage" Margin="-2,-2,-2,0">
                <DockPanel Height="522">
                    <Grid DockPanel.Dock="top" Height="247">
                        <Label x:Name="labelcategories" Content="Categories" Margin="10,9,439,208"/>
                        <Label x:Name="labelscripts" Content="Scripts" Margin="361,10,10,207"/>
                        <ListView x:Name="listViewScriptCategosies"  Margin="10,44,439,10" >
                        </ListView>
                        <ListView x:Name="listViewScripts" Margin="361,44,10,10" >

                        </ListView>

                    </Grid>
                    <Grid >
                        <RichTextBox x:Name="RichTextBoxScriptComments" VerticalScrollBarVisibility="Auto" IsReadOnly="True" HorizontalScrollBarVisibility="Auto" Margin="10,36,10,10">
                            <FlowDocument PageWidth="Auto">
                                <FlowDocument.Resources>
                                    <Style TargetType="{x:Type Paragraph}">
                                        <Setter Property="Margin" Value="0"/>
                                    </Style>
                                </FlowDocument.Resources>
                                <Paragraph>
                                    <Run Text="Comments"/>
                                </Paragraph>
                            </FlowDocument>
                        </RichTextBox>
                        <Button x:Name="buttonUse" Content="Use" HorizontalAlignment="Left" Margin="580,0,0,0" VerticalAlignment="Top" Width="184" />
                    </Grid>
                </DockPanel>
            </TabItem>
            <TabItem Header="Source" Margin="-2,-2,-2,0">
                <WrapPanel>
                    <RichTextBox x:Name="richTextBoxSource" HorizontalAlignment="Left" MinHeight="240"   MinWidth="400" VerticalAlignment="Top"  Margin="5,5,5,5" 
                    VerticalScrollBarVisibility="Visible"
                    HorizontalScrollBarVisibility="Auto" Height="500"
                     >
                        <FlowDocument PageWidth="Auto">
                            <FlowDocument.Resources>
                                <Style TargetType="{x:Type Paragraph}">
                                    <Setter Property="Margin" Value="0"/>
                                </Style>
                            </FlowDocument.Resources>
                            <Paragraph>
                                <Run Text="#Source"/>
                            </Paragraph>
                            <Paragraph>
                                <Run Text=" { echo 'hello world!' } "/>
                            </Paragraph>
                        </FlowDocument>
                    </RichTextBox>
                </WrapPanel>
            </TabItem>
            <TabItem Header="Transformation" Margin="-2,-2,-2,0">
                <DockPanel Height="522">
                    <Grid DockPanel.Dock="top" Height="247">
                        <Label x:Name="label" Content="Methods" Margin="10,9,439,208"/>
                        <Label x:Name="label2" Content="Selected" Margin="439,10,10,207"/>
                        <ListView x:Name="listViewMethods"  Margin="10,44,439,10" >
                        </ListView>

                        <Grid Margin="350,0,355,0">
                            <Button x:Name="buttonAddMethod" Content="add" HorizontalAlignment="Right"  VerticalAlignment="Center" Height="25" Width="57" Margin="5,180,5,40" />
                            <Button x:Name="buttonDelMethod" Content="del" HorizontalAlignment="Right"  VerticalAlignment="Center" Height="25" Width="57" Margin="5,210,5,10" />
                        </Grid>
                        <ListView x:Name="listViewSelectedMethods" Margin="434,44,10,10" >

                        </ListView>

                    </Grid>
                    <Grid >
                        <RichTextBox x:Name="RichTextBoxComments" VerticalScrollBarVisibility="Auto" IsReadOnly="True" HorizontalScrollBarVisibility="Auto" Margin="10,36,10,10">
                            <FlowDocument PageWidth="Auto">
                                <FlowDocument.Resources>
                                    <Style TargetType="{x:Type Paragraph}">
                                        <Setter Property="Margin" Value="0"/>
                                    </Style>
                                </FlowDocument.Resources>
                                <Paragraph>
                                    <Run Text="Comments"/>
                                </Paragraph>
                            </FlowDocument>
                        </RichTextBox>
                        <Button x:Name="buttonApply" Content="Apply" HorizontalAlignment="Left" Margin="580,0,0,0" VerticalAlignment="Top" Width="184"/>
                    </Grid>
                </DockPanel>
            </TabItem>
            <TabItem Header="Result" Margin="-2,-2,-2,0">
                <Grid Height="517">
                    <RichTextBox x:Name="richTextBoxResult" HorizontalAlignment="Left"  VerticalAlignment="Top" Height="251"   MinWidth="400"
                    VerticalScrollBarVisibility="Visible"
                    HorizontalScrollBarVisibility="Auto" Margin="0,0,0,256"
                     >
                        <FlowDocument PageWidth="Auto">
                            <FlowDocument.Resources>
                                <Style TargetType="{x:Type Paragraph}">
                                    <Setter Property="Margin" Value="0"/>
                                </Style>
                            </FlowDocument.Resources>
                            <Paragraph>
                                <Run Text="Result"/>
                            </Paragraph>
                        </FlowDocument>
                    </RichTextBox>
                    <Button x:Name="buttonBuild" Content="Build" HorizontalAlignment="Right"  VerticalAlignment="Bottom" Height="25" Width="98" Margin="0,0,10,226"/>
					<Button x:Name="buttonCopyRes" Content="Copy" HorizontalAlignment="Right"  VerticalAlignment="Bottom" Height="25" Width="98" Margin="0,0,113,226"/>
                    <RichTextBox x:Name="richTextBoxResultLog" VerticalScrollBarVisibility="Auto" IsReadOnly="True" HorizontalScrollBarVisibility="Auto" HorizontalAlignment="Left" Height="211" VerticalAlignment="Bottom" Width="774">
                        <FlowDocument PageWidth="Auto">
                            <FlowDocument.Resources>
                                <Style TargetType="{x:Type Paragraph}">
                                    <Setter Property="Margin" Value="0"/>
                                </Style>
                            </FlowDocument.Resources>
                            <Paragraph>
                                <Run Text="logs"/>
                            </Paragraph>
                        </FlowDocument>
                    </RichTextBox>
                </Grid>
            </TabItem>
            <TabItem Header="Launcher" Margin="-2,-2,-2,0">
				<DockPanel Height="520">
                    <Grid DockPanel.Dock="Top">
                        <Grid Grid.Column="0" Margin="0,0,193,0">
                            <ListView x:Name="listViewLaunchers" Margin="10,0" />
                        </Grid>
                        <Grid Margin="596,10,10,10">
							<CheckBox x:Name="checkBoxHiden" Content="hiden window" Margin="13,82,-13,69"/>
                            <Button x:Name="buttonEncode" Content="Encode" HorizontalAlignment="Right"  VerticalAlignment="Top" Height="25" Width="75" Grid.Column="0" Grid.Row="0" Margin="0,107,90,0"/>
                            <Button x:Name="buttonDecode" Content="Decode" HorizontalAlignment="Right"  VerticalAlignment="Top" Height="25" Width="75" Grid.Column="0" Margin="0,107,10,0"/>
                            <Button x:Name="buttonCopy" Content="Copy" HorizontalAlignment="Right"  VerticalAlignment="Top" Height="25" Width="75" Grid.Column="0" Margin="0,137,10,0" RenderTransformOrigin="0.067,0.44"/>
                            <Button x:Name="buttonRun" Content="Run" HorizontalAlignment="Right"  VerticalAlignment="Top" Height="25" Width="75" Grid.Column="0" Margin="0,137,90,0"/>
                        </Grid>
                    </Grid>
                    <Grid DockPanel.Dock="Bottom" >
						<Label x:Name="labelLengthLaunch" Content="Length:"  VerticalAlignment="Top" Margin="10,0,0,0" />
                        <RichTextBox x:Name="RichTextResultLaunch"  VerticalScrollBarVisibility="Auto" HorizontalScrollBarVisibility="Auto" Margin="10,36,10,10">
                        </RichTextBox>

                    </Grid>

                </DockPanel>
            </TabItem>
        </TabControl>
    </DockPanel>
	</Window>
'@
}
